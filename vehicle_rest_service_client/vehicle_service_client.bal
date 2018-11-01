
import ballerina/test;
import ballerina/http;
import ballerina/config;
import ballerina/io;
import ballerina/math;
import ballerina/task;
import ballerina/runtime;
import ballerina/time;
import ballerina/log;
int randspeed;
int randoil;
int randmileage;
int rand;
int count;
task:Timer? timer;
string currentDate;
string vehicleID;
string randLocation;
string currentTime;
string startTime;
string endTime;
int formatedTime;


type Vehicle record {
    string id;
    int mileage;
    int speed;
    string time;
    string date;
    int OliLevel;
    string location;



};


function main(string... args) {
        randomVehicleId();
        randomLocation();

        //interval for 2 minutes
        scheduleTimer(0,config:getAsInt("interval"));


    //sleep after 10 minutes
    runtime:sleep(config:getAsInt("sleep"));

}


endpoint http:Client clientEP {
  // url:"http://172.17.0.2:8280/vehiclemgt/1.0.0" //APIM
  url:"http://localhost:9090/vehiclemgt" // local
  //  url:"http://172.17.0.3:9090/vehiclemgt" //Docker
//url:"http://vehicle-telemetry-service/vehiclemgt" //kubernetes
};

// Function to POST resource 'recordspeed'.
function ResourcerecordSpeed() {

    http:Request req = new;
    //creating a intance of vehicle record
    Vehicle v1={id:vehicleID,time:currentTime,speed:randspeed,date:currentDate};
    req.setJsonPayload(check <json> v1);
    req.addHeader("Authorization",config:getAsString("Authorization"));
    req.addHeader("Content-Type","application/json");

    io:println(check <json> v1);
    var response = clientEP->post("/recordSpeed", req);
    match response {
        http:Response resp => {
            io:println("\nSending speed :");
            var msg = resp.getJsonPayload();
            match msg {
                json jsonPayload => {
                    io:println(jsonPayload);
                }
                error err => {
                    io:println(msg);
                    io:println(resp.getBodyParts());
                    io:println("Error Executed");
                    log:printError(err.message, err = err);
                }
            }
        }
        error err => { log:printError(err.message, err = err); }

    }




}

//Function to test GET resource 'getSpeed'.
function ResourcegetSpeed() {

        http:Request req = new;
        // Send 'GET' request and obtain the response.
        //http:Response response =new;
        req.addHeader("Authorization", config:getAsString("Authorization"));
        req.addHeader("Content-Type", "application/json");
        startTime= config:getAsString("startTime");
        endTime= config:getAsString("endTime");
        // Send 'GET' request and obtain the response.
        var response = clientEP->get("/getSpeed/" + vehicleID+"/timerange/"+startTime+"/"+endTime, message = req);

        match response {
            http:Response resp => {

                // Check whether the response is as expected.
                var message = resp.getJsonPayload();
                match message {
                    json jsonPayload => {
                        io:println("\nspeed Respond:");
                       // io:println(jsonPayload);
                    }
                    error err => {
                        io:println(message);
                      //  io:println(resp.getBodyParts());
                        io:println("Error Executed in speed respond");
                        log:printError(err.message, err = err);
                    }
                }
                io:println(message);
            }
        error err => { log:printError(err.message, err = err); }
    }

}


// Function to POST resource 'recordOilLevel'.
function ResourcerecordOilLevel() {

    http:Request req = new;
    //creating a intance of vehicle record
    Vehicle v1={id:vehicleID,time:currentTime,date:currentDate,OliLevel:randoil};
  //  io:println(v1);
    req.setJsonPayload(check <json> v1);
    req.addHeader("Authorization",config:getAsString("Authorization"));
    req.addHeader("Content-Type","application/json");

    io:println(check <json> v1);
    var response = clientEP->post("/recordOilLevel", req);
    match response {
        http:Response resp => {
            io:println("\nSending record oil level request:");
            var msg = resp.getJsonPayload();
            match msg {
                json jsonPayload => {
                    io:println(jsonPayload);
                }
                error err => {
                    io:println(msg);
                    io:println(resp.getBodyParts());
                    io:println("Error Executed");
                    log:printError(err.message, err = err);
                }
            }
        }
        error err => { log:printError(err.message, err = err); }

    }




}

//Function to test GET resource 'getOilLevel'.
function ResourcegetOilLevel() {

    http:Request req = new;
    //add the access token to the header
    req.addHeader("Authorization", config:getAsString("Authorization"));
    req.addHeader("Content-Type", "application/json");

    // Send 'GET' request and obtain the response.
    var response = clientEP->get("/getOilLevel/" + vehicleID, message = req);

    match response {
        http:Response resp => {

            // Check whether the response is as expected.
            var message = resp.getJsonPayload();
            match message {
                json jsonPayload => {
                    io:println("\noil level Respond:");
                    io:println(jsonPayload);
                }
                error err => {
                    io:println(message);
                    //  io:println(resp.getBodyParts());
                    io:println("Error Executed");
                    log:printError(err.message, err = err);
                }
            }
            io:println(message);
        }
        error err => { log:printError(err.message, err = err); }
    }

}


// Function to POST resource 'recordMileage'.
function ResourcerecordMileage() {

    http:Request req = new;
    //creating a intance of vehicle record
    Vehicle v1={id:vehicleID,time:currentTime,speed:randspeed,date:currentDate,mileage:randmileage};
    req.setJsonPayload(check <json> v1);
    req.addHeader("Authorization",config:getAsString("Authorization"));
    req.addHeader("Content-Type","application/json");

    io:println(check <json> v1);
    var response = clientEP->post("/recordMileage", req);
    match response {
        http:Response resp => {
            io:println("\nSending record mileage request:");
            var msg = resp.getJsonPayload();
            match msg {
                json jsonPayload => {
                    io:println(jsonPayload);
                }
                error err => {
                    io:println(msg);
                    io:println(resp.getBodyParts());
                    io:println("Error Executed");
                    log:printError(err.message, err = err);
                }
            }
        }
        error err => { log:printError(err.message, err = err); }

    }
}

//Function to test GET resource 'getMileage'.
function ResourcegetMileage() {

    http:Request req = new;
    // Send 'GET' request and obtain the response.
    //http:Response response =new;
    req.addHeader("Authorization", config:getAsString("Authorization"));
    req.addHeader("Content-Type", "application/json");

    // Send 'GET' request and obtain the response.
    var response = clientEP->get("/getMileage/" + vehicleID, message = req);


    match response {
        http:Response resp => {

            // Check whether the response is as expected.
            var message = resp.getJsonPayload();
            match message {
                json jsonPayload => {
                    io:println("\nmileage Respond:");
                    io:println(jsonPayload);
                }
                error err => {
                    io:println(message);
                    //  io:println(resp.getBodyParts());
                    io:println("Error Executed");
                    log:printError(err.message, err = err);
                }
            }
            io:println(message);
        }
        error err => { log:printError(err.message, err = err); }
    }

}

// Function to POST resource 'recordLocation'.
function ResourcerecordLocation() {

    http:Request req = new;
    //creating a intance of vehicle record
    Vehicle v1={id:vehicleID,time:currentTime,speed:randspeed,date:currentDate,location:randLocation};
    req.setJsonPayload(check <json> v1);
    req.addHeader("Authorization",config:getAsString("Authorization"));
    req.addHeader("Content-Type","application/json");

    io:println(check <json> v1);
    var response = clientEP->post("/recordLocation", req);
    match response {
        http:Response resp => {
            io:println("\nSending record location request:");
            var msg = resp.getJsonPayload();
            match msg {
                json jsonPayload => {
                    io:println(jsonPayload);
                }
                error err => {
                    io:println(msg);
                    io:println(resp.getBodyParts());
                    io:println("Error Executed");
                    log:printError(err.message, err = err);
                }
            }
        }
        error err => { log:printError(err.message, err = err); }

    }
}
//Function to test GET resource 'getLocation'.
function ResourcegetLocation() {

    http:Request req = new;
    // Send 'GET' request and obtain the response.
    //http:Response response =new;
    req.addHeader("Authorization", config:getAsString("Authorization"));
    req.addHeader("Content-Type", "application/json");

    // Send 'GET' request and obtain the response.
    var response = clientEP->get("/getLocation/" + vehicleID, message = req);


    match response {
        http:Response resp => {

            // Check whether the response is as expected.
            var message = resp.getJsonPayload();
            match message {
                json jsonPayload => {
                    io:println("\nlocation Respond:");
                    io:println(jsonPayload);
                }
                error err => {
                    io:println(message);
                    //  io:println(resp.getBodyParts());
                    io:println("Error Executed");
                    log:printError(err.message, err = err);
                }
            }
            io:println(message);
        }
        error err => { log:printError(err.message, err = err); }
    }

}



//Function to test delect resource 'delectVehicle'.
function ResourcedelectVehicle() {

    http:Request req = new;

    req.addHeader("Authorization", config:getAsString("Authorization"));
    req.addHeader("Content-Type", "application/json");

    // Send 'delete' request and obtain the response.
    var response = clientEP->delete("/deleteVehicle/" + vehicleID, req);

    match response {
        http:Response resp => {
            io:println("\nDELETE request:");
            // Check whether the response is as expected.
            var message = resp.getJsonPayload();
            match message {
                json jsonPayload => {

                    io:println(jsonPayload);
                }
                error err => {
                    io:println(message);
                    //  io:println(resp.getBodyParts());
                    io:println("Error Executed in deleting the vehicle");
                    log:printError(err.message, err = err);
                }
            }
            io:println(message);
        }
        error err => { log:printError(err.message, err = err); }
    }

}





function scheduleTimer(int delay, int interval) {
    // Point to the trigger function.
    (function() returns error?) onTriggerFunction = onTrigger;
    // Point to the error function.
    (function (error)) onErrorFunction = onError;
    // Register a task with given ‘onTrigger’ and ‘onError’ functions, and with given ‘delay’ and ‘interval’ times.
    timer = new task:Timer(onTriggerFunction, onErrorFunction, interval, delay = delay);
    // Start the timer.
    timer.start();
}
// Define the ‘onError’ function for the task timer.
function onError(error e) {
    io:print("[ERROR] failed to execute timed task");
    io:println(e);

}

function onTrigger() returns error? {

        time:Time time = time:currentTime();
        io:println(time["time"]);
        formatedTime=(time["time"])/1000;
        io:println(formatedTime);
        currentDate = time.format("yyyy-MM-dd");
        log:printInfo("Current date: " + currentDate);
        currentTime = time.format("HH:mm:ss");
        log:printInfo("Current time: " + currentTime);
        randspeed = math:randomInRange( config:getAsInt("speedRangeMin"),config:getAsInt("speedRangeMax"));
        log:printInfo("current Vehicle speed :" + randspeed);
        randoil=math:randomInRange(config:getAsInt("oilrangeMin"),config:getAsInt("oilrangeMax"));
        log:printInfo("current Vehicle oil level :" + randoil);
        randmileage=math:randomInRange(config:getAsInt("mileageMin"),config:getAsInt("mileageMax"));
        log:printInfo("current Vehicle mileage :" + randmileage);
        ResourcerecordSpeed();
       ResourcegetSpeed();
       // ResourcerecordOilLevel();
      //  ResourcegetOilLevel();
      //  ResourcerecordMileage();
      //  ResourcegetMileage();
      //  ResourcerecordLocation();
      //  ResourcegetLocation();
       // ResourcedelectVehicle();



    return () ;
}

function randomVehicleId() {
    string[] b = ["a","b", "c", "d","e", "f","g", "h","i","j","k","l","m","n","o","p","q","r","s","t","u","w","x","y","z"];
    int randnumber5=math:randomInRange(0,25);
    int randnumber6=math:randomInRange(0,25);
    string char1=b[randnumber5];
    string char2=b[randnumber6];
    string sperate="-";
    int randnumber1= math:randomInRange(0,10);
    int randnumber2= math:randomInRange(0,10);
    int randnumber3= math:randomInRange(0,10);
    int randnumber4= math:randomInRange(0,10);
     vehicleID=char1+char2+sperate+<string>randnumber1+<string>randnumber2+<string>randnumber3+<string>randnumber4;
    log:printInfo("vehicle id :"+vehicleID);
}

function randomLocation() {
    string sperate="-";
    int randnumber1= math:randomInRange(0,10);
    int randnumber2= math:randomInRange(0,10);
    int randnumber3= math:randomInRange(0,10);
    int randnumber4= math:randomInRange(0,10);
    randLocation="Location"+sperate+<string>randnumber1+<string>randnumber2+<string>randnumber3+<string>randnumber4;
    log:printInfo("location  :"+randLocation);
}

