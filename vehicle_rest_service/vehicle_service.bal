import ballerina/io;
import ballerina/http;
import ballerina/log;
import ballerinax/docker;

type Vehicle record {
    string id,
    string mileage,
    string speed,
    string time,
    string date,
    string OliLevel,
    string location,


};

// vehicle management is done using an in-memory map.
map<Vehicle> vehicleMap;

//@docker:Config {
//    registry: "vehicle_telemetry_service",
//    name: "vehiclemgt",
//    tag: "v1.0"
//}
//@docker:Expose {}
//endpoint http:Listener listener {
//    port: 9090
//};


endpoint http:Listener listener {
   port:9090
};

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
        // Find the requested vehicle from the map and retrieve it in json format.
        json? payload = check <json>vehicleMap[vehicleId];

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
                io:println("Incoming speed");
                io:println(jsonPayload);
                Vehicle v1 = check <Vehicle>jsonPayload;
                string vId = v1.id;
                string vtime = v1.time;
                string vspeed = v1.speed;
                string vdate = v1.date;
                vehicleMap[vId] = v1;
                payload = { status: "Vehicle speed is recored .", vehicleId: vId };

                // Create response message.
                http:Response response = new;
                io:println("outgoing speed");
                io:println(jsonPayload);
                response.setJsonPayload(untaint jsonPayload);


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
        // Find the requested vehicle from the map and retrieve it in json format.
        json? payload = check <json>vehicleMap[vehicleId];

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
                io:println("Incoming oil level");
                io:println(jsonPayload);
                Vehicle v1 = check <Vehicle>jsonPayload;
                string vId = v1.id;
                string vtime = v1.time;
                string vspeed = v1.speed;
                string vdate = v1.date;
                vehicleMap[vId] = v1;
                payload = { status: "Vehicle oillevel is recored .", vehicleId: vId };

                // Create response message.
                http:Response response = new;
                io:println("outgoing oil level");
                io:println(jsonPayload);
                response.setJsonPayload(untaint jsonPayload);


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
    // vehicle using path '/getMileage/<vehicleId>'

    @http:ResourceConfig {
        methods: ["GET"],
        path: "/getMileage/{vehicleId}"
    }

    getMileage(endpoint client, http:Request req, string vehicleId) {
        // Find the requested vehicle from the map and retrieve it in json format.
        json? payload = check <json>vehicleMap[vehicleId];

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
                io:println("Incoming mileage");
                io:println(jsonPayload);
                Vehicle v1 = check <Vehicle>jsonPayload;
                string vId = v1.id;
                string vtime = v1.time;
                string vspeed = v1.speed;
                string vdate = v1.date;
                vehicleMap[vId] = v1;
                payload = { status: "Vehicle mileage is recored .", vehicleId: vId };

                // Create response message.
                http:Response response = new;
                io:println("outgoing mileage");
                io:println(jsonPayload);
                response.setJsonPayload(untaint jsonPayload);


                // Send response to the client.
                client->respond(response) but { error e => log:printError(
                                                               "Error sending response", err = e) };

            }
            error err => {
                log:printError(err.message, err = err);
            }
        }



    }





}