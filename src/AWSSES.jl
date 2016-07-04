#==============================================================================#
# AWSSES.jl
#
# SES API. See http://aws.amazon.com/documentation/ses/
#
# Copyright Sam O'Connor 2016 - All rights reserved
#==============================================================================#


__precompile__()


module AWSSES

export ses_send, ses_send_raw, ses_send_attachments


using AWSCore
using SymDict
using Retry



function ses(aws::AWSConfig, query)

    query["AWSAccessKeyId"] = aws[:creds].secret_key

    if aws[:creds].token != ""
        query["SecurityToken"] = aws[:creds].token
    end

    do_request(post_request(aws, "email", "", query))
end


function ses_send(aws::AWSConfig; to="", from="", subject="", body="")

    ses(aws, Dict(
        "Action" => "SendEmail",
        "Source" => from,
        "Destination.ToAddresses.member.1" => to,
        "Message.Subject.Data" => subject,
        "Message.Body.Text.Data" => body))
end


function ses_send_raw(aws::AWSConfig; to="", from="", raw="")

    ses(aws, Dict(
        "Action" => "SendRawEmail",
        "Source" => from,
        "Destination.ToAddresses.member.1" => to,
        "RawMessage.Data" => base64encode(raw)))
end


#    e.g. attachments=[("bar.txt", "text/plain", "bar\n"),
#                      ("foo.txt", "text/plain", "foo\n")])

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



end # module AWSSES



#==============================================================================#
# End of file.
#==============================================================================#
