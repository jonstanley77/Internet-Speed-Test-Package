#!/usr/bin/python3
import sys
import mimetypes
import smtplib
from email.message import EmailMessage

textVar = sys.argv[1]
textVar2 = sys.argv[2]
#adapted for network security device
# send an unauthenticated email via SMTP server
def send_email(mail_from='bluedevilshield@duke.edu',
               mail_to=textVar2,
               bcc=False,
               subject='important security alert',
               text=textVar,
               attachments=['/mnt/mmcblk0p3/ubuntu/etc/my_mail/dukeoit.png'],
               smtp_server='smtp.duke.edu'):
    #ask user for email address to send notifications
    if not mail_to:
        print ('~~~~~You have not yet set up an email address for notifications!, you should have been asked this on first boot~~~~~ ')
        mail_to = input("What email address would you like to send your notifications to: ")

    if not mail_from or not mail_to or not subject or not text:
        return('There is missing information')
    # Create the container email message.

      msg = EmailMessage()
      msg['Subject'] = subject
      msg['From'] = mail_from
      msg['To'] = mail_to
      if bcc:
          msg['Bcc'] = mail_from
      # add the text to the message
      msg.set_content(text, 'plain')

      for attachment in attachments:
     	#do we have a valid attachment?
        if True or os.path.isfile(attachment):
  	     #what kind of file is our attachment?
              ctype, encoding = mimetypes.guess_type(attachment)
              if ctype is None or encoding is not None:
                  # could not figure out what type of file this is
                  ctype = 'application/octet-stream'
              maintype, subtype = ctype.split('/', 1)
              with open(attachment, 'rb') as f:
                  msg.add_attachment(f.read(),
                                     maintype=maintype,
                                     subtype=subtype,
                                     filename=attachment.split('/')[-1])
     # send SMTP message
      with smtplib.SMTP(smtp_server) as s:
          s.send_message(msg)

if __name__ == '__main__':
    send_email()
