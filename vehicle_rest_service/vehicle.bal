import ballerina/io;
//map<Vehicle > vehicleMap;
type Vehicle object {
   public string vehicleId,
   public string mileage,
    public string speed,
    public string OliLevel,
    public string location,


};
//Returns single vehicle entry according to given id
//public function getVehicle(string vehicleId) returns json {
//    vehicleMap default;
//    Vehicle obj = vehicleMap[vehicleId] ?: default;
//    json payload = check <json>obj;
//    return payload;
//}
//
////Adds a single cache entry to the store
//public function setVehicle(json jsObj) returns json {
//    string vehicleId= jsObj["vehicleId"].toString();
//    jsObj.remove(vehicleId);
//    vehicleMap[vehicleId] = check <Vehicle>jsObj;
//    return jsObj;
//}