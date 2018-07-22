import ballerina/http;
import ballerina/time;

import ballerinax/kubernetes;
import ballerinax/docker;

// Change this object
type Data object {
    string message;
};

@docker:Config {
    registry: "gcr.io/optimistic-yew-208712",
    name: "hello-ballerina",
    tag: "0.0.2 "
}

// @kubernetes:Ingress {
//     endpointName: "hello-service",
//     targetPath: "/" 
// }  

@kubernetes:Service {
    name: "hello-service",
    serviceType: "NodePort"
}
@http:ServiceConfig {
    basePath: "/"
}

@kubernetes:Deployment {
    // TODO: move this to configuration file for k8s
    replicas: 2,
    name: "hello-deployment",
    image: "gcr.io/optimistic-yew-208712/hello-ballerina:0.0.2",
    // TODO: find out how can push to gcr.io (authz issues)
    // buildImage: true,
    // push: true
}

service<http:Service> hello bind { port: 9090 } {

    // for k8s ingress to work
    @http:ResourceConfig {
        path: "/"
    }
    health (endpoint caller, http:Request request) {
        http:Response res = new;
        res.statusCode = 200;
        _ = caller -> respond(res);
    }

    @http:ResourceConfig {
        methods: ["POST"],
        path: "/created",
        consumes: ["application/json"],
        produces: ["application/json"],
        body: "data"
    }
    echo (endpoint caller, http:Request request, Data data) {
        var now = time:nanoTime();
        http:Response response = new;
        json js = {
            createdAt: now,
            method: "POST"
        };
        response.setPayload(js);
        _ = caller ->respond(response);
    }

    @http:ResourceConfig {
        methods: ["GET"],
        path: "/hey",
        produces: ["application/json"]
    }
    hi (endpoint caller, http:Request request) {
        var now = time:nanoTime();
        http:Response response = new;
        json js = {
            createdAt: now,
            method: "GET"
        };
        response.setPayload(js);
        _ = caller ->respond(response);
    }
}