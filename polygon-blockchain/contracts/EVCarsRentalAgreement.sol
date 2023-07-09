// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EVCarsRentalAgreement {
    struct RentalAgreement {
        uint256 rentalDateTime;
        string vinNumber;
        string carInsuranceNumber;//
        uint256 returnDateTime;
        string rentalCompanyName;
        string userRetailerName;//address
        uint256 receiptNumber;
        string companyLocation;
        uint256 costPerDay;
    }

    struct VehicleInfo {
        string vin;
        string make;
        uint256 year;
        string color;
        uint256 costPerDay;
    }

    struct EVCarState {
        uint256 batteryLife;
        uint256 batteryLevel;
        uint256 usableBatteryLevel;
        uint256 batteryRange;
    }

    mapping(uint256 => RentalAgreement) private rentalAgreements;
    mapping(string => VehicleInfo) private vehicleInfo;
    mapping(string => EVCarState) private evCarState;

    event RentalAgreementCreated(
        uint256 indexed receiptNumber,
        uint256 rentalDateTime,
        string indexed vinNumber,
        string rentalCompanyName,
        string userRetailerName
    );

    event EVCarReturned(
        uint256 indexed receiptNumber,
        uint256 returnDateTime,
        uint256 additionalCosts,
        uint256 batteryLife,
        uint256 batteryLevel,
        uint256 usableBatteryLevel,
        uint256 batteryRange
    );
//add modifier -->rental agency
//require stmt--> _returnDateTime > _rentalDateTime
//
    function createRentalAgreement(
        uint256 _receiptNumber,
        uint256 _rentalDateTime,
        string memory _vinNumber,
        string memory _carInsuranceNumber,
        uint256 _returnDateTime,
        string memory _rentalCompanyName,
        string memory _userRetailerName,
        string memory _companyLocation,
        uint256 _costPerDay
    ) external {
        RentalAgreement memory agreement = RentalAgreement(
            _rentalDateTime,
            _vinNumber,
            _carInsuranceNumber,
            _returnDateTime,
            _rentalCompanyName,
            _userRetailerName,
            _receiptNumber,
            _companyLocation,
            _costPerDay
        );
        rentalAgreements[_receiptNumber] = agreement;

        emit RentalAgreementCreated(
            _receiptNumber,
            _rentalDateTime,
            _vinNumber,
            _rentalCompanyName,
            _userRetailerName
        );
    }

    function returnEVCar(
        uint256 _receiptNumber,
        uint256 _returnDateTime,
        uint256 _additionalCosts,
        uint256 _batteryLife,
        uint256 _batteryLevel,
        uint256 _usableBatteryLevel,
        uint256 _batteryRange
    ) external {
        RentalAgreement storage agreement = rentalAgreements[_receiptNumber];
        require(agreement.returnDateTime >= _returnDateTime, "Invalid return date/time");

        emit EVCarReturned(
            _receiptNumber,
            _returnDateTime,
            _additionalCosts,
            _batteryLife,
            _batteryLevel,
            _usableBatteryLevel,
            _batteryRange
        );
    }

    function getRentalAgreement(uint256 _receiptNumber) external view returns (
        uint256 rentalDateTime,
        string memory vinNumber,
        string memory carInsuranceNumber,
        uint256 returnDateTime,
        string memory rentalCompanyName,
        string memory userRetailerName,
        string memory companyLocation,
        uint256 costPerDay
    ) {
        RentalAgreement memory agreement = rentalAgreements[_receiptNumber];
        return (
            agreement.rentalDateTime,
            agreement.vinNumber,
            agreement.carInsuranceNumber,
            agreement.returnDateTime,
            agreement.rentalCompanyName,
            agreement.userRetailerName,
            agreement.companyLocation,
            agreement.costPerDay
        );
    }

    function getEVCarState(string memory _vin) external view returns (
        uint256 batteryLife,
        uint256 batteryLevel,
        uint256 usableBatteryLevel,
        uint256 batteryRange
    ) {
        EVCarState memory state = evCarState[_vin];
        return (
            state.batteryLife,
            state.batteryLevel,
            state.usableBatteryLevel,
            state.batteryRange
        );
    }

    function addVehicleInfo(
        string memory _vin,
        string memory _make,
        uint256 _year,
        string memory _color,
        uint256 _costPerDay
    ) external {
        VehicleInfo memory info = VehicleInfo(
            _vin,
            _make,
            _year,
            _color,
            _costPerDay
        );
        vehicleInfo[_vin] = info;
    }

    function updateEVCarState(
        string memory _vin,
        uint256 _batteryLife,
        uint256 _batteryLevel,
        uint256 _usableBatteryLevel,
        uint256 _batteryRange
    ) external {
        EVCarState memory state = EVCarState(
            _batteryLife,
            _batteryLevel,
            _usableBatteryLevel,
            _batteryRange
        );
        evCarState[_vin] = state;
    }
}
