#==============================================================================#
# AWSSES.jl
#
# SES API. See http://aws.amazon.com/documentation/ses/
#
# Copyright OC Technology Pty Ltd 2016 - All rights reserved
#==============================================================================#


__precompile__()


module AWSSES

export ses_send, ses_send_raw, ses_send_attachments


using AWSCore
using SymDict
using Retry



ses(aws::AWSConfig, action, args) = AWSCore.Services.email(aws, action, args)


"""
    ses_send([::AWSConfig]; to=, from=, subject=, body=)

Send plain text email.

```
ses_send(
    to="sam@octech.com.au"
    from="sam@octech.com.au"
    subject="Hi Sam!"
    body="Hello!"
)
```
"""

function ses_send(aws::AWSConfig; to="", from="", subject="", body="")

    ses(aws, "SendEmail", Dict(
        "Source" => from,
        "Destination.ToAddresses.member.1" => to,
        "Message.Subject.Data" => subject,
        "Message.Body.Text.Data" => body))
end

ses_send(; a...) = ses_send(default_aws_config(); a...)


"""
    ses_send_raw([::AWSConfig]; to=, from=, raw=)

Send a raw email.

`raw` must contain both headers and message body.
"""

function ses_send_raw(aws::AWSConfig; to="", from="", raw="")

    ses(aws, "SendRawEmail", Dict(
        "Source" => from,
        "Destination.ToAddresses.member.1" => to,
        "RawMessage.Data" => base64encode(raw)))
end

ses_send_raw(;a...) = ses_send_raw(default_aws_config(); a...)


"""
    ses_send_attachments([::AWSConfig],
                         to=, from=, subject=, body=,
                         attachments=[])

Send an email with attachments.
```
ses_send_attachments(to="sam@octech.com.au", from="sam@octech.com.au"
                     subject="Attachments attached",    
                     body="See attached attachments...",
                     [("bar.txt", "text/plain", "bar\\n"),
                      ("foo.txt", "text/plain", "foo\\n")])
```
"""

function  ses_send_attachments(aws::AWSConfig;
                               to="", from="", subject="", body="",
                               attachments=[])

    ses_send_raw(
        aws,
        to=to,
        from=from,
        raw = AWSCore.mime_multipart(
            """
            To: $to
            From: $from
            Subject: $subject
            """,
            [("", "text/plain", body), attachments...]))
end

ses_send_attachments(; a...) = ses_send_attachments(default_aws_config(); a...)


end # module AWSSES



#==============================================================================#
# End of file.
#==============================================================================#
