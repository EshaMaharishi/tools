echo "Moving binaries from " $1 " to workspace" 
mkdir -p ./_binaries/current
mv mongo* ./_binaries/current/
cp _binaries/$1/* .
