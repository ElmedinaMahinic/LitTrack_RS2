using Microsoft.ML;
using Microsoft.ML.Trainers;
using Microsoft.ML.Data;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using litTrack.Services.Database;
using litTrack.Model.DTOs;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;


namespace litTrack.Services.Recommender
{
    public class KnjigaRecommenderService : IKnjigaRecommenderService
    {
        private readonly IMapper _mapper;
        private readonly _210078Context _context;
        private static MLContext? mlContext;
        private static ITransformer? model;
        private static readonly object isLocked = new();
        private static Task? trainingTask;


        private const string ModelFilePath = "books-recommender-model.zip";

        public KnjigaRecommenderService(_210078Context context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        public async Task<List<KnjigaDTO>> GetRecommendedBooks(int knjigaId)
        {
            var exists = await _context.StavkaNarudzbes
                .AnyAsync(x => x.KnjigaId == knjigaId && !x.IsDeleted);

            if (!exists)
                return new List<KnjigaDTO>();

            if (mlContext == null)
            {
                bool needsTraining = false;

                lock (isLocked)
                {
                    if (mlContext == null)
                    {
                        mlContext = new MLContext();

                        if (File.Exists(ModelFilePath))
                        {
                            using var stream = new FileStream(ModelFilePath, FileMode.Open, FileAccess.Read, FileShare.Read);
                            model = mlContext.Model.Load(stream, out _);
                        }
                        else
                        {
                            needsTraining = true;
                        }
                    }
                }

                if (needsTraining)
                {
                    lock (isLocked)
                    {
                        trainingTask ??= TrainData();
                    }

                    await trainingTask;
                }

            }


            if (model == null)
                return new List<KnjigaDTO>();

            var books = await _context.Knjigas
                .Where(x => x.KnjigaId != knjigaId && !x.IsDeleted)
                .ToListAsync();

            using var predictionEngine = mlContext.Model.CreatePredictionEngine<BookEntry, CopurchasePrediction>(model);

            var predictions = new List<(Knjiga, float)>();

            foreach (var book in books)
            {
                var prediction = predictionEngine.Predict(new BookEntry
                {
                    BookID = (uint)knjigaId,
                    CoPurchaseBookID = (uint)book.KnjigaId
                });

                predictions.Add((book, prediction.Score));
            }

            var topBooks = predictions
                .OrderByDescending(x => x.Item2)
                .Take(3)
                .Select(x => x.Item1)
                .ToList();

            return _mapper.Map<List<KnjigaDTO>>(topBooks);
        }

        public async Task TrainData()
        {
            if (mlContext == null)
                mlContext = new MLContext();

            var orders = await _context.Narudzbas
                .Include(o => o.StavkaNarudzbes)
                .Where(o => !o.IsDeleted)
                .ToListAsync();

            var data = new List<BookEntry>();

            foreach (var order in orders)
            {
                var itemIds = order.StavkaNarudzbes
                    .Where(s => !s.IsDeleted)
                    .Select(s => s.KnjigaId)
                    .Distinct()
                    .ToList();

                for (int i = 0; i < itemIds.Count; i++)
                    for (int j = 0; j < itemIds.Count; j++)
                    {
                        if (i == j) continue;

                        data.Add(new BookEntry
                        {
                            BookID = (uint)itemIds[i],
                            CoPurchaseBookID = (uint)itemIds[j],
                            Label = 1f
                        });
                    }
            }

            if (!data.Any())
                return;

            var trainData = mlContext.Data.LoadFromEnumerable(data);

            var options = new MatrixFactorizationTrainer.Options
            {
                MatrixColumnIndexColumnName = nameof(BookEntry.BookID),
                MatrixRowIndexColumnName = nameof(BookEntry.CoPurchaseBookID),
                LabelColumnName = nameof(BookEntry.Label),
                LossFunction = MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass,
                Alpha = 0.01,
                Lambda = 0.005,
                NumberOfIterations = 100,
                C = 0.00001
            };

            var est = mlContext.Recommendation().Trainers.MatrixFactorization(options);
            model = est.Fit(trainData);

            using var stream = new FileStream(ModelFilePath, FileMode.Create, FileAccess.Write, FileShare.Write);
            mlContext.Model.Save(model, trainData.Schema, stream);
        }
    }

    public class BookEntry
    {
        [KeyType(count: 10000)]
        public uint BookID { get; set; }

        [KeyType(count: 10000)]
        public uint CoPurchaseBookID { get; set; }

        public float Label { get; set; }
    }

    public class CopurchasePrediction
    {
        public float Score { get; set; }
    }
}
