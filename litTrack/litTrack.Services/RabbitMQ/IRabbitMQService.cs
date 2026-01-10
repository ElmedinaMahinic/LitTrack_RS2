using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using litTrack.Model.Messages;

namespace litTrack.Services.RabbitMQ
{
    public interface IRabbitMQService
    {
        Task SendAnEmail(EmailDTO mail);
    }
}
