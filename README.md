    software engineering course app


## setup


# backend
cd backend
python main.py


# hub
cd hub
python main.py

# device
cd devices/{device}
nohup python smart_light.py > output.log 2>&1 &

# web
cd web
yarn dev
