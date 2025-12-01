using GestionIntApi.Models;
using GestionIntApi.Repositorios.Interfaces;
using Microsoft.Extensions.Options;
using System.Net;
using System.Net.Mail;

namespace GestionIntApi.Repositorios.Implementacion
{
    public class EmailService : IEmailService
    {

        private readonly EmailSettings _settings;

        public EmailService(IOptions<EmailSettings> settings)
        {
            _settings = settings.Value;
        }

        public async Task SendEmailAsync(string to, string subject, string body)
        {
            var message = new MailMessage();
            message.From = new MailAddress(_settings.From);
            message.To.Add(to);
            message.Subject = subject;
            message.Body = body;
            message.IsBodyHtml = true;

            var smtp = new SmtpClient(_settings.Host)
            {
                Port = _settings.Port,
                Credentials = new NetworkCredential(_settings.From, _settings.Password),
                EnableSsl = true
            };

            await smtp.SendMailAsync(message);
        }
    }
}
