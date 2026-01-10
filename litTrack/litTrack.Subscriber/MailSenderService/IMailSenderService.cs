using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace litTrack.Subscriber.MailSenderService
{
    public interface IMailSenderService
    {
        Task SendEmail(EmailDTO email);
    }
}
