rm -rvf "tools/apiGenerator/build"
rm -rvf "Modules/Networking/Sources/Networking/"
openapi-generator generate -i "tools/apiGenerator/api.yaml" -g swift5 -o "tools/apiGenerator/build"
cp -r "tools/apiGenerator/build/OpenAPIClient/Classes/OpenAPIs/" "Modules/Networking/Sources/Networking/"
