wget https://github.com/container2wasm/container2wasm/releases/download/v0.8.0/container2wasm-v0.8.0-linux-amd64.tar.gz
tar -xvf container2wasm-v0.8.0-linux-amd64.tar.gz
sudo mv c2w /usr/local/bin/

mkdir -p ./guides/web/containers
          
for dockerfile in guides/*.dockerfile; do
  image_name=$(basename "$dockerfile" .dockerfile)
  
  echo "Building Docker image for $dockerfile with tag $image_name"
  docker build -t "$image_name" -f "$dockerfile" .
  
  c2w "$image_name" ./guides/web/containers/"$image_name"00.wasm
done