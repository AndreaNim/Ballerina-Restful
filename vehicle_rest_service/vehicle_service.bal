import ballerina/io;
import ballerina/http;
import ballerina/log;



endpoint http:Listener listener {
    port:9090
};
// vehicle management is done using an in-memory map.

map<string > vehicleMap;

// RESTful service.
@http:ServiceConfig { basePath: "/vehiclemgt" }
service<http:Service> vehicleMgt bind listener {

    // Resource that handles the HTTP GET requests
    // vehicle using path '/getspeed/<vehicleId>'
    @http:ResourceConfig {
        methods: ["GET"],
        path: "/getSpeed/{vehicleId}"
    }

    getSpeed(endpoint client, http:Request req, string vehicleId) {
        // Find the requested vehicle from the map and retrieve it in string format.
        string? payload = vehicleMap[vehicleId];
        http:Response response;
        if (payload == null) {
            payload = "Vehicle : " + vehicleId + " cannot be found.";
        }

        // Set the JSON payload in the outgoing response message.
          response.setJsonPayload(untaint payload);

        // Send response to the client.
        _ = client->respond(response);
    }


    // Resource that handles the HTTP POST requests
    // '/vehicle' to create a new vehicle.
    @http:ResourceConfig {
        methods: ["POST"],
        path: "/recordSpeed"
    }
    recordSpeed(endpoint client, http:Request req) {
        var vehicleReq = req.getJsonPayload();
        json payload;
        match vehicleReq {
            json jsonPayload => {
                io:println("Incoming");
                io:println(jsonPayload);

                string vehicleId = jsonPayload.Vehicle.ID.toString();
                vehicleMap[vehicleId] = vehicleId ;

                payload = { status: "Vehicle speed is recored .", vehicleId: vehicleId };

                // Create response message.
                http:Response response=new;
                io:println("outgoing");
                io:println(payload);
                response.setJsonPayload(untaint payload);


                // Send response to the client.
                client->respond(response) but { error e => log:printError(
                                                          "Error sending response", err = e) };
            }
            error err => {
                log:printError(err.message, err = err);
            }
        }

    }




    // Resource that handles the HTTP GET requests
    // vehicle using path '/getOilLevel/<vehicleId>'

    @http:ResourceConfig {
        methods: ["GET"],
        path: "/getOilLevel/{vehicleId}"
    }

    getOilLevel(endpoint client, http:Request req, string vehicleId) {
        // Find the requested vehicle from the map and retrieve it in string format.
        string? payload = vehicleMap[vehicleId];
        http:Response response;
        if (payload == null) {
            payload = "Vehicle : " + vehicleId + " cannot be found.";
        }

        // Set the JSON payload in the outgoing response message.
        response.setJsonPayload(untaint payload);

        // Send response to the client.
        _ = client->respond(response);
    }


    // Resource that handles the HTTP POST requests

    @http:ResourceConfig {
        methods: ["POST"],
        path: "/recordOilLevel"
    }
    recordOilLevel(endpoint client, http:Request req) {

        var vehicleReq = req.getJsonPayload();
        json payload;
        match vehicleReq {
            json jsonPayload => {
                io:println("Incoming");

                io:println(jsonPayload);

                string vehicleId = jsonPayload.Vehicle.ID.toString();
                vehicleMap[vehicleId] = vehicleId;

                payload = { status: "Vehicle oil level is recorded .", vehicleId: vehicleId };
            }
            error err => {
                log:printError(err.message, err = err);
            }
        }


        // Create response message.
        http:Response response;
        response.setJsonPayload(untaint payload);


        // Send response to the client.
        _ = client->respond(response);
    }

    // Resource that handles the HTTP GET requests
    // vehicle using path '/getMileage/<vehicleId>'

    @http:ResourceConfig {
        methods: ["GET"],
        path: "/getMileage/{vehicleId}"
    }

    getMileage(endpoint client, http:Request req, string vehicleId) {
        // Find the requested vehicle from the map and retrieve it in string format.
        string? payload = vehicleMap[vehicleId];
        http:Response response;
        if (payload == null) {
            payload = "Vehicle : " + vehicleId + " cannot be found.";
        }

        // Set the JSON payload in the outgoing response message.
        response.setJsonPayload(untaint payload);

        // Send response to the client.
        _ = client->respond(response);
    }


    // Resource that handles the HTTP POST requests

    @http:ResourceConfig {
        methods: ["POST"],
        path: "/recordMileage"
    }
    recordMileage(endpoint client, http:Request req) {

        var vehicleReq = req.getJsonPayload();
        json payload;
        match vehicleReq {
            json jsonPayload => {
                io:println("Incoming");

                io:println(jsonPayload);

                string vehicleId = jsonPayload.Vehicle.ID.toString();
                vehicleMap[vehicleId] = vehicleId;

                payload = { status: "Vehicle mileage is recored.", vehicleId: vehicleId };
            }
            error err => {
                log:printError(err.message, err = err);

            }
        }


        // Create response message.
        http:Response response;
        response.setJsonPayload(untaint payload);


        // Send response to the client.
        _ = client->respond(response);
    }





}