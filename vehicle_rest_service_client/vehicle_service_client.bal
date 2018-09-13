
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
string currentTime;

function main(string... args) {
        randomVehicleId();
        //intervel for 2 minutes
        scheduleTimer(0,120000);


//sleep after 10 minutes
    runtime:sleep(600000);

}


endpoint http:Client clientEP {
    url:"http://localhost:9090/vehiclemgt"
};

// Function to POST resource 'recordspeed'.
function ResourcerecordSpeed() {
    http:Request req = new;

    json jsonMsg =  {"Vehicle":{"ID":vehicleID, "Time":currentTime,"Speed":randspeed,"Date":currentDate}};
    io:println(jsonMsg);
    req.setJsonPayload(jsonMsg);
    var response = clientEP->post("/recordSpeed", jsonMsg);
    match response {
        http:Response resp => {
            io:println("\nSending request:");
            var msg = resp.getJsonPayload();
            match msg {
                json jsonPayload => {
                    io:println(jsonPayload);
                }
                error err => {
                    io:println("Error Executed");
                    log:printError(err.message, err = err);
                }
            }
        }
        error err => { log:printError(err.message, err = err); }

    }

    io:println(jsonMsg);


}

//Function to test GET resource 'getSpeed'.
function ResourcegetSpeed() {
    // Send 'GET' request and obtain the response.
    http:Response response =new;
    response= check clientEP -> get("/getSpeed/"+vehicleID);

    // Check whether the response is as expected.
    json resPayload = check response.getJsonPayload();

    io:println(resPayload.toString());
}

// Function to POST resource 'recordOilLevel'.
function ResourcerecordOilLevel() {
    http:Request req = new;

    json jsonMsg =  {"Vehicle":{"ID":vehicleID, "Time":currentTime,"Oil level":randoil,"Date":currentDate}};
    req.setJsonPayload(jsonMsg);
    var response = clientEP->post("/recordOilLevel", jsonMsg);
    match response {
        http:Response resp => {
            io:println("\nPOST request:");
            var msg = resp.getJsonPayload();
            match msg {
                json jsonPayload => {
                    io:println(jsonPayload);
                }
                error err => {
                    log:printError(err.message, err = err);
                }
            }
        }
        error err => { log:printError(err.message, err = err); }

    }

    io:println(jsonMsg);

}

//Function to test GET resource 'getOliLevel'.
function ResourcegetOilLevel() {
    // Send 'GET' request and obtain the response.
    http:Response response = check clientEP -> get("/getOilLevel/"+vehicleID);

    // Check whether the response is as expected.
    json resPayload = check response.getJsonPayload();

    io:println(resPayload.toString());
}


// Function to POST resource 'recordMileage'.
function ResourcerecordMileage() {
    http:Request req = new;

    json jsonMsg =  {"Vehicle":{"ID":vehicleID, "Time":currentTime,"Mileage":randmileage,"Date":currentDate}};
    req.setJsonPayload(jsonMsg);
    var response = clientEP->post("/recordMileage", jsonMsg);
    match response {
        http:Response resp => {
            io:println("\nPOST request:");
            var msg = resp.getJsonPayload();
            match msg {
                json jsonPayload => {
                    io:println(jsonPayload);
                }
                error err => {
                    log:printError(err.message, err = err);
                }
            }
        }
        error err => { log:printError(err.message, err = err); }

    }

    io:println(jsonMsg);

}

//Function to test GET resource 'getMileage'.
function ResourcegetMileage() {
    // Send 'GET' request and obtain the response.
    http:Response response = check clientEP -> get("/getMileage/"+vehicleID);


    // Check whether the response is as expected.
    json resPayload = check response.getJsonPayload();

    io:println(resPayload.toString());
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
    try {
        time:Time time = time:currentTime();
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
        ResourcerecordOilLevel();
        ResourcegetOilLevel();
        ResourcerecordMileage();
        ResourcegetMileage();
    }catch (error err) {
        log:printError("error log with cause", err = err);

    }


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

