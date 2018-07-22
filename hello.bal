import ballerina/http;
import ballerina/time;

import ballerinax/kubernetes;
import ballerinax/docker;


type Person object {
    string firstName;
    string lastName;
};
@kubernetes:Ingress {
    endpointName: "simple",
    targetPath: "/" 
}  

@kubernetes:Service {
    name: "hello-service",
    serviceType: "LoadBalancer"
}
@http:ServiceConfig {
    basePath: "/"
}
@kubernetes:Deployment {
    replicas: 2,
    name: "hello-deployment",
    image: "gcr.io/optimistic-yew-208712/hello-ballerina:0.0.1"
}
service<http:Service> hello bind { port: 9090 } {

    @http:ResourceConfig {
        methods: ["POST"],
        path: "/",
        consumes: ["application/json"],
        produces: ["application/json"],
        body: "person"
    }
    hi (endpoint caller, http:Request request, Person person) {
        var now = time:nanoTime();
        var name = person.firstName;
        http:Response response = new;
        json js = {
            createdAt: now
        };
        response.setPayload(js);
        _ = caller ->respond(response);
    }
}
