using litTrack.Model.DTOs;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace litTrack.Services.Recommender
{
    public interface IKnjigaRecommenderService
    {
        Task<List<KnjigaDTO>> GetRecommendedBooks(int knjigaId);
        Task TrainData();
    }
}
