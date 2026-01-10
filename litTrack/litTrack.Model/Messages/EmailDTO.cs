using System;
using System.Collections.Generic;
using System.Text;

namespace litTrack.Model.Messages
{
    public class EmailDTO
    {
        public string EmailTo { get; set; } = null!;
        public string ReceiverName { get; set; } = null!;
        public string Subject { get; set; } = null!;
        public string Message { get; set; } = null!;
    }
}
