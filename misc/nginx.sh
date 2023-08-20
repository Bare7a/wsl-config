sudo apt install nginx
sudo systemctl start nginx

sudo bash -c "cat > /etc/nginx/sites-available/default << EOF
upstream home_box_client {
  server localhost:3000;
  server localhost:3001;
}

upstream home_box_server {
  server localhost:5000;
  server localhost:5001;
}

server {
  listen 443 ssl;
  server_name home.box;
  proxy_set_header Accept '*/*';

  ssl_certificate /etc/nginx/sites-available/home_box.crt;
  ssl_certificate_key /etc/nginx/sites-available/home_box.key;

  location / {
    root /home/$USER/home-box-client/dist;
  }
}


server {
  listen 443 ssl;
  server_name api.home.box;
  proxy_set_header Accept '*/*';

  ssl_certificate /etc/nginx/sites-available/home_box.crt;
  ssl_certificate_key /etc/nginx/sites-available/home_box.key;

  location / {
    proxy_pass http://home_box_server/;
  }
}

server {
  listen 443 ssl;
  server_name app.home.box;
  proxy_set_header Accept '*/*';

  ssl_certificate /etc/nginx/sites-available/home_box.crt;
  ssl_certificate_key /etc/nginx/sites-available/home_box.key;

  location / {
    proxy_pass http://home_box_client/;
  }
}
EOF
"

sudo bash -c "cat > /etc/nginx/sites-available/home_box.cnf << EOF
[req]
distinguished_name = req_distinguished_name
x509_extensions = v3_req
prompt = no
[req_distinguished_name]
C = BG
ST = SF
L = Sofia
O = Home Box LTD
OU = Home Box
CN = home.box
[v3_req]
keyUsage = critical, digitalSignature, keyAgreement
extendedKeyUsage = serverAuth
subjectAltName = @alt_names
[alt_names]
DNS.1 = home.box
DNS.2 = *.home.box
EOF
"

sudo openssl req -x509 -nodes -days 730 -newkey rsa:2048 -keyout /etc/nginx/sites-available/home_box.key -out /etc/nginx/sites-available/home_box.crt -config /etc/nginx/sites-available/home_box.cnf -sha256

----
chmod ugo+rwx ~/

npx degit solidjs/templates/js home-box-client
cd ~/home-box-client
npm install
npm run build
cd ~/home-box-client && npm run dev -- --debug --port 3000
cd ~/home-box-client && npm run dev -- --debug --port 3001

npm install -g json-server
mkdir ~/home-box-server
cd ~/home-box-server

bash -c "cat > /home/$USER/home-box-server/db.json << EOF
{
  \"posts\": [
    { \"id\": 1, \"title\": \"json-server\", \"author\": \"typicode\" }
  ],
  \"comments\": [
    { \"id\": 1, \"body\": \"some comment\", \"postId\": 1 }
  ],
  \"profile\": { \"name\": \"typicode\" }
}
EOF
"

cd ~/home-box-server && json-server --watch db.json --port 5000
cd ~/home-box-server && json-server --watch db.json --port 5001
