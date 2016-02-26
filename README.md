# AWSSES

AWS SES Interface for Julia

[![Build Status](https://travis-ci.org/samoconnor/AWSSES.jl.svg)](https://travis-ci.org/samoconnor/AWSSES.jl)

```julia
using AWSSES

aws = AWSCore.aws_config()

AWSSES.ses_send(
    aws,
    to="sam@octe.ch",
    from="sam@octe.ch",
    subject="Hello",
    body="Test")

AWSSES.ses_send_attachments(
    aws,
    to="sam@octe.ch",
    from="sam@octe.ch",
    subject="hello",
    body="test\n",
    attachments=[("bar.txt", "text/plain", "bar\n"),
                 ("foo.txt", "text/plain", "foo\n")])
```
