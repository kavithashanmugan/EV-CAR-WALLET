// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EVDataStorage {
    struct BatteryData {
        uint256 batteryLife;
        uint256 batteryLevel;
        uint256 usableBatteryLevel;
        uint256 batteryRange;
        uint256 idealBatteryRange;
        uint256 estimatedBatteryRange;
        uint256 lastChargeCurrentRequest;
        uint256 lastChargeEnergyAdded;
        uint256 lastChargeRangeAddedIdeal;
        uint256 lastChargeRangeAddedRated;
    }

    struct VehicleData {
        uint256 insideTemperature;
        uint256 outsideTemperature;
        uint256 odometer;
        uint256 estimatedMaxRange;
        uint256 estimatedMaxRangeVsOdometer;
        uint256 numberOfBatteryCycles;
    }

    mapping(string => mapping(address => mapping(uint256 => BatteryData))) private batteryDataRecords;
    mapping(string => mapping(address => mapping(uint256 => VehicleData))) private vehicleDataRecords;

    event BatteryDataStored(
        string indexed vin,
        address indexed user,
        uint256 indexed timestamp,
        uint256 batteryLife,
        uint256 batteryLevel,
        uint256 usableBatteryLevel,
        uint256 batteryRange,
        uint256 idealBatteryRange,
        uint256 estimatedBatteryRange,
        uint256 lastChargeCurrentRequest,
        uint256 lastChargeEnergyAdded,
        uint256 lastChargeRangeAddedIdeal,
        uint256 lastChargeRangeAddedRated
    );

    event VehicleDataStored(
        string indexed vin,
        address indexed user,
        uint256 indexed timestamp,
        uint256 insideTemperature,
        uint256 outsideTemperature,
        uint256 odometer,
        uint256 estimatedMaxRange,
        uint256 estimatedMaxRangeVsOdometer,
        uint256 numberOfBatteryCycles
    );

    function storeBatteryData(
        string memory _vin,
        uint256 _timestamp,
        uint256 _batteryLife,
        uint256 _batteryLevel,
        uint256 _usableBatteryLevel,
        uint256 _batteryRange,
        uint256 _idealBatteryRange,
        uint256 _estimatedBatteryRange,
        uint256 _lastChargeCurrentRequest,
        uint256 _lastChargeEnergyAdded,
        uint256 _lastChargeRangeAddedIdeal,
        uint256 _lastChargeRangeAddedRated
    ) external {
        BatteryData memory newBatteryData = BatteryData(
            _batteryLife,
            _batteryLevel,
            _usableBatteryLevel,
            _batteryRange,
            _idealBatteryRange,
            _estimatedBatteryRange,
            _lastChargeCurrentRequest,
            _lastChargeEnergyAdded,
            _lastChargeRangeAddedIdeal,
            _lastChargeRangeAddedRated
        );
        batteryDataRecords[_vin][msg.sender][_timestamp] = newBatteryData;

        emit BatteryDataStored(
            _vin,
            msg.sender,
            _timestamp,
            _batteryLife,
            _batteryLevel,
            _usableBatteryLevel,
            _batteryRange,
            _idealBatteryRange,
            _estimatedBatteryRange,
            _lastChargeCurrentRequest,
            _lastChargeEnergyAdded,
            _lastChargeRangeAddedIdeal,
            _lastChargeRangeAddedRated
        );
    }

    function storeVehicleData(
        string memory _vin,
        uint256 _timestamp,
        uint256 _insideTemperature,
        uint256 _outsideTemperature,
        uint256 _odometer,
        uint256 _estimatedMaxRange,
        uint256 _estimatedMaxRangeVsOdometer,
        uint256 _numberOfBatteryCycles
    ) external {
        VehicleData memory newVehicleData = VehicleData(
            _insideTemperature,
            _outsideTemperature,
            _odometer,
            _estimatedMaxRange,
            _estimatedMaxRangeVsOdometer,
            _numberOfBatteryCycles
        );
        vehicleDataRecords[_vin][msg.sender][_timestamp] = newVehicleData;

        emit VehicleDataStored(
            _vin,
            msg.sender,
            _timestamp,
            _insideTemperature,
            _outsideTemperature,
            _odometer,
            _estimatedMaxRange,
            _estimatedMaxRangeVsOdometer,
            _numberOfBatteryCycles
        );
    }

    function getBatteryData(string memory _vin, address _user, uint256 _timestamp) external view returns (
        uint256 batteryLife,
        uint256 batteryLevel,
        uint256 usableBatteryLevel,
        uint256 batteryRange,
        uint256 idealBatteryRange,
        uint256 estimatedBatteryRange,
        uint256 lastChargeCurrentRequest,
        uint256 lastChargeEnergyAdded,
        uint256 lastChargeRangeAddedIdeal,
        uint256 lastChargeRangeAddedRated
    ) {
        BatteryData memory batteryData = batteryDataRecords[_vin][_user][_timestamp];
        return (
            batteryData.batteryLife,
            batteryData.batteryLevel,
            batteryData.usableBatteryLevel,
            batteryData.batteryRange,
            batteryData.idealBatteryRange,
            batteryData.estimatedBatteryRange,
            batteryData.lastChargeCurrentRequest,
            batteryData.lastChargeEnergyAdded,
            batteryData.lastChargeRangeAddedIdeal,
            batteryData.lastChargeRangeAddedRated
        );
    }

    function getVehicleData(string memory _vin, address _user, uint256 _timestamp) external view returns (
        uint256 insideTemperature,
        uint256 outsideTemperature,
        uint256 odometer,
        uint256 estimatedMaxRange,
        uint256 estimatedMaxRangeVsOdometer,
        uint256 numberOfBatteryCycles
    ) {
        VehicleData memory vehicleData = vehicleDataRecords[_vin][_user][_timestamp];
        return (
            vehicleData.insideTemperature,
            vehicleData.outsideTemperature,
            vehicleData.odometer,
            vehicleData.estimatedMaxRange,
            vehicleData.estimatedMaxRangeVsOdometer,
            vehicleData.numberOfBatteryCycles
        );
    }
}
