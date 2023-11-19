This folder contains the `docker-compose.yaml` file to used to build and run all the microservices containers and their respective databases along with the API Gateway container.

To build the images:
`docker-compose build`

To run the application (all the containers):
`docker-compose up`

To build and run simultanuously:
`docker-compose up --build`

To stop the application:
`docker-compose down`
If you want to delete all the images after stopping the container you can add the optional flag `--rmi all`
