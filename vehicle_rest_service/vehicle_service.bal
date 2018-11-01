import ballerina/io;
import ballerina/http;
import ballerina/log;
import ballerinax/kubernetes;
import ballerina/math;
import ballerina/time;


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
map<Vehicle >vehicleMap;
//json [] vehicleArray;
string key1 = "Record - ";
int i=1;

//
//@kubernetes:Deployment {
//enableLiveness:true,
//push:true,
//image:"index.docker.io/$env{DOCKER_USERNAME}/vehicle-restful-service:1.0",
//username:"$env{DOCKER_USERNAME}",
//password:"$env{DOCKER_PASSWORD}"
//}
//
//
//@kubernetes:Ingress {
//    hostname:"vehicle-telemetry-service",
//    name:"vehicle-restful-service"
//
//}
//@kubernetes:Service {
//    serviceType:"NodePort",
//    name:"vehicle-restful-service"
//}


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
    port: 9090
};


// RESTful service.
@http:ServiceConfig { basePath: "/vehiclemgt" }
service<http:Service> vehicleMgt bind listener {
   // Vehicle v1;
    string vId ;
    string vtime ;
    string vspeed ;
    string vdate ;


    // Resource that handles the HTTP GET requests
    // vehicle using path '/getspeed/<vehicleId>'
    @http:ResourceConfig {
        methods: ["GET"],
        path: "/getSpeed/{vehicleId}/timerange/{startTime}/{endTime}"
    }

    getSpeed(endpoint client, http:Request req, string vehicleId, string startTime,
             string endTime) {

    io:println("Map");
    io:println(vehicleMap);
    // io:println(vehicleMap.values());
    //  io:println(vehicleMap.values(i)["time"]);
    time:Time startTimeTime = time:parse(startTime, "yyyy-MM-dd'T'HH:mm:ss");
    time:Time endTimeTime = time:parse(endTime, "yyyy-MM-dd'T'HH:mm:ss");

    int startTimeMM =(startTimeTime["time"] /1000);
    int endTimeMM =(endTimeTime["time"] /1000);
    io:println(startTimeMM);
    io:println(endTimeMM);

    http:Response response;

    foreach key,entry in vehicleMap{
    io:println(entry.time);
    io:println(entry.date);
    io:println(key);
    string recordtime = entry.time;
    string recorddate= entry.date;

    string recordDateTime = recorddate +"T" + recordtime;
    io:println(recordtime);
    io:println(recorddate);
    io:println(recordDateTime);
    // Parse a time string of a given format.

    time:Time recordTimeTime = time:parse(recordDateTime, "yyyy-MM-dd'T'HH:mm:ss");

    int recordTimeMM =(recordTimeTime["time"] /1000);


    io:println("...........");
    io:println(recordTimeMM);
    io:println("...........");

    if(compareTime(startTimeMM,recordTimeMM,endTimeMM)){
        // Find the requested vehicle from the map and retrieve it in json format.
        json? payload = check <json>vehicleMap[key];
        // Set the JSON payload in the outgoing response message.
        response.setJsonPayload(untaint payload);
        io:println(vehicleMap[key]);
        io:println(payload);
    }
        else {
            log:printInfo("time is not in range.enter a valid time range");
            json payload2 = "time is not in range.enter a valid time range";
            // Set the JSON payload in the outgoing response message.
            response.setJsonPayload(untaint payload2);
        }

}

    // Set the JSON payload in the outgoing response message.
 //   response.setJsonPayload(untaint payload);
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
                vId = (untaint v1.id);
                vtime = (untaint v1.time);
                vspeed = (untaint v1.speed);
                vdate =(untaint v1.date);
                vehicleMap[key1+i] =v1;
                i+=1;

                io:println(vehicleMap);

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

    //@http:ResourceConfig {
    //    methods: ["GET"],
    //    path: "/getOilLevel/{vehicleId}"
    //}
    //
    //getOilLevel(endpoint client, http:Request req, string vehicleId) {
    //    // Find the requested vehicle from the map and retrieve it in json format.
    //    json? payload = check <json>vehicleMap[vehicleId];
    //
    //    http:Response response;
    //    if (payload == null) {
    //        payload = "Vehicle : " + vehicleId + " cannot be found.";
    //    }
    //
    //    // Set the JSON payload in the outgoing response message.
    //    response.setJsonPayload(untaint payload);
    //
    //    // Send response to the client.
    //    _ = client->respond(response);
    //}
    //
    //
    //// Resource that handles the HTTP POST requests
    //
    //@http:ResourceConfig {
    //    methods: ["POST"],
    //    path: "/recordOilLevel"
    //}
    //recordOilLevel(endpoint client, http:Request req) {
    //
    //    var vehicleReq = req.getJsonPayload();
    //    json payload;
    //    match vehicleReq {
    //        json jsonPayload => {
    //            io:println("Incoming oil level");
    //            io:println(jsonPayload);
    //            Vehicle v1 = check <Vehicle>jsonPayload;
    //            string vId = v1.id;
    //            string vtime = v1.time;
    //            string vspeed = v1.speed;
    //            string vdate = v1.date;
    //            vehicleMap[vId] = v1;
    //            payload = { status: "Vehicle oillevel is recored .", vehicleId: vId };
    //
    //            // Create response message.
    //            http:Response response = new;
    //            io:println("outgoing oil level");
    //            io:println(jsonPayload);
    //            response.setJsonPayload(untaint jsonPayload);
    //
    //
    //            // Send response to the client.
    //            client->respond(response) but { error e => log:printError(
    //                                                           "Error sending response", err = e) };
    //
    //        }
    //        error err => {
    //            log:printError(err.message, err = err);
    //        }
    //    }
    //
    //}
    //
    //// Resource that handles the HTTP GET requests
    //// vehicle using path '/getMileage/<vehicleId>'
    //@http:ResourceConfig {
    //    methods: ["GET"],
    //    path: "/getMileage/{vehicleId}"
    //}
    //
    //getMileage(endpoint client, http:Request req, string vehicleId) {
    //    // Find the requested vehicle from the map and retrieve it in json format.
    //    json? payload = check <json>vehicleMap[vehicleId];
    //
    //    http:Response response;
    //    //if the vehicle id is not in the map
    //    if (payload == null) {
    //        payload = "Vehicle : " + vehicleId + " cannot be found.";
    //    }
    //
    //    // Set the JSON payload in the outgoing response message.
    //    response.setJsonPayload(untaint payload);
    //
    //    // Send response to the client.
    //    _ = client->respond(response);
    //}
    //
    //
    //// Resource that handles the HTTP POST requests
    //
    //@http:ResourceConfig {
    //    methods: ["POST"],
    //    path: "/recordMileage"
    //}
    //recordMileage(endpoint client, http:Request req) {
    //
    //    var vehicleReq = req.getJsonPayload();
    //    json payload;
    //    match vehicleReq {
    //        json jsonPayload => {
    //            io:println("Incoming mileage");
    //            io:println(jsonPayload);
    //            Vehicle v1 = check <Vehicle>jsonPayload;
    //            string vId = v1.id;
    //            string vtime = v1.time;
    //            string vspeed = v1.speed;
    //            string vdate = v1.date;
    //            vehicleMap[vId] = v1;
    //            payload = { status: "Vehicle mileage is recored .", vehicleId: vId };
    //
    //            // Create response message.
    //            http:Response response = new;
    //            io:println("outgoing mileage");
    //            io:println(jsonPayload);
    //            response.setJsonPayload(untaint jsonPayload);
    //
    //
    //            // Send response to the client.
    //            client->respond(response) but { error e => log:printError(
    //                                                           "Error sending response", err = e) };
    //
    //        }
    //        error err => {
    //            log:printError(err.message, err = err);
    //        }
    //    }
    //}
    //
    //
    //
    //
    //// Resource that handles the HTTP GET requests
    //// vehicle using path '/getLocation/<vehicleId>'
    //@http:ResourceConfig {
    //    methods: ["GET"],
    //    path: "/getLocation/{vehicleId}"
    //}
    //
    //getLocation(endpoint client, http:Request req, string vehicleId) {
    //    // Find the requested vehicle from the map and retrieve it in json format.
    //    json? payload = check <json>vehicleMap[vehicleId];
    //
    //    http:Response response;
    //    //if the vehicle id is not in the map
    //    if (payload == null) {
    //        payload = "Vehicle : " + vehicleId + " cannot be found.";
    //    }
    //
    //    // Set the JSON payload in the outgoing response message.
    //    response.setJsonPayload(untaint payload);
    //
    //    // Send response to the client.
    //    _ = client->respond(response);
    //}
    //
    //
    //// Resource that handles the HTTP POST requests
    //
    //@http:ResourceConfig {
    //    methods: ["POST"],
    //    path: "/recordLocation"
    //}
    //recordLocation(endpoint client, http:Request req) {
    //
    //    var vehicleReq = req.getJsonPayload();
    //    json payload;
    //    match vehicleReq {
    //        json jsonPayload => {
    //            io:println("Incoming location");
    //            io:println(jsonPayload);
    //            Vehicle v1 = check <Vehicle>jsonPayload;
    //            string vId = v1.id;
    //            string vtime = v1.time;
    //            string vspeed = v1.speed;
    //            string vdate = v1.date;
    //            vehicleMap[vId] = v1;
    //            payload = { status: "Vehicle location is recored .", vehicleId: vId };
    //
    //            // Create response message.
    //            http:Response response = new;
    //            io:println("outgoing location");
    //            io:println(jsonPayload);
    //            response.setJsonPayload(untaint jsonPayload);
    //
    //
    //            // Send response to the client.
    //            client->respond(response) but { error e => log:printError(
    //                                                           "Error sending response", err = e) };
    //
    //        }
    //        error err => {
    //            log:printError(err.message, err = err);
    //        }
    //    }
    //
    //
    //
    //}
    //
    //// Resource that handles the HTTP DELETE requests, which are directed to the path
    //// '/deleteVehicle/<vehicleId>' to delete an existing Vehicle.
    //@http:ResourceConfig {
    //    methods: ["DELETE"],
    //    path: "/deleteVehicle/{vehicleId}"
    //}
    //deleteVehicle(endpoint client, http:Request req, string vehicleId) {
    //    json? payload = check <json>vehicleMap[vehicleId];
    //
    //    http:Response response;
    //
    //    // Remove the requested vehicle from the map.
    //    // _ = vehicleMap.remove(vehicleId);
    //    log:printInfo("\nvehilce deleted");
    //    payload = "Order : " + vehicleId + " removed.";
    //    // Set a generated payload with vehicle status.
    //    response.setJsonPayload(untaint payload);
    //
    //    // Send response to the client.
    //    _ = client->respond(response);
   // }





}
function compareTime(int timeStart,int timeRecord,int timeEnd) returns boolean{
if(timeStart<timeRecord && timeRecord<=timeEnd){

    return true;
}
else{

 log:printInfo("time is not in range.enter a valid time range");
 return false;
}

}