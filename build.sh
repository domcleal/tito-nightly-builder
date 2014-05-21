#!/bin/bash -xe

ssh -o "BatchMode yes" people.redhat.com "rm public_html/copr/tito-nightly/*" || true

if [ -e tito ]; then
    (cd tito && git pull)
else
    git clone https://github.com/dgoodwin/tito
fi

cd tito
grep -q copr-domcleal-nightly rel-eng/releasers.conf || (
    cat << EOF >> rel-eng/releasers.conf

[copr-domcleal-nightly]
releaser = tito.release.CoprReleaser
project_name = tito-nightly
upload_command = scp %(srpm)s people.redhat.com:public_html/copr/tito-nightly/
remote_location = http://people.redhat.com/~dcleal/copr/tito-nightly/
builder.test = 1
EOF
)

tito release copr-domcleal-nightly
