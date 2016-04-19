export commit_id=`git log -1 --pretty=format:"%H"`

git config --global push.default simple
git config --global user.name "Isuru Fernando"
git config --global user.email "isuruf-bot@users.noreply.github.com"

set +x
git clone "https://${GH_TOKEN}@github.com/isuruf-bot/sympy-paper.git" upload -q
set -x

cd upload
git checkout -b pdfs --track origin/pdfs;

if [ "${TRAVIS_PULL_REQUEST}" = "false" ]; then
    export name=paper-${TRAVIS_BRANCH}.pdf
else
    export name=paper-${TRAVIS_PULL_REQUEST}.pdf
fi

mv ../paper.pdf ${name}
git add ${name}
git commit -m "Upload new pdf [skip ci]."
git push -q

export payload='{"state":"success","target_url":"https://github.com/isuruf-bot/sympy-paper/blob/pdfs/'${name}'","description":"Pdf uploading succeeded!","context":"continuous-integration/latex-pdf"}'

set +x
curl -X POST -H "Content-Type: application/json" -d '$payload' https://api.github.com/repos/sympy/sympy-paper/statuses/${commit_id}?access_token=${GH_TOKEN}
set -x
