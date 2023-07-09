import { ethers } from "hardhat";
import { Contract, ContractFactory } from "ethers";
import { expect } from "chai";

describe("EVCarsRentalAgreement", () => {
  let rentalContract: Contract;

  beforeEach(async () => {
    const RentalContract: ContractFactory = await ethers.getContractFactory("EVCarsRentalAgreement");
    rentalContract = await RentalContract.deploy();
    await rentalContract.deployed();
  });

  it("should create a rental agreement", async () => {
    const receiptNumber = 1;
    const rentalDateTime = Math.floor(Date.now() / 1000);
    const vinNumber = "1ABC234DEF567GHI89";
    const carInsuranceNumber = "INS12345";
    const returnDateTime = rentalDateTime + 2 * 24 * 60 * 60; // 2 days
    const rentalCompanyName = "XYZ Car Rentals";
    const userRetailerName = "John Doe";
    const companyLocation = "City, State, Country";
    const costPerDay = ethers.utils.parseEther("0.1");

    await rentalContract.createRentalAgreement(
      receiptNumber,
      rentalDateTime,
      vinNumber,
      carInsuranceNumber,
      returnDateTime,
      rentalCompanyName,
      userRetailerName,
      companyLocation,
      costPerDay
    );

    const rentalAgreement = await rentalContract.getRentalAgreement(receiptNumber);

    expect(rentalAgreement.rentalDateTime).to.equal(rentalDateTime);
    expect(rentalAgreement.vinNumber).to.equal(vinNumber);
    expect(rentalAgreement.carInsuranceNumber).to.equal(carInsuranceNumber);
    expect(rentalAgreement.returnDateTime).to.equal(returnDateTime);
    expect(rentalAgreement.rentalCompanyName).to.equal(rentalCompanyName);
    expect(rentalAgreement.userRetailerName).to.equal(userRetailerName);
    expect(rentalAgreement.companyLocation).to.equal(companyLocation);
    expect(rentalAgreement.costPerDay).to.equal(costPerDay);
  });

  it("should return the EV car", async () => {
    const receiptNumber = 1;
    const rentalDateTime = Math.floor(Date.now() / 1000);
    const vinNumber = "1ABC234DEF567GHI89";
    const carInsuranceNumber = "INS12345";
    const returnDateTime = rentalDateTime + 2 * 24 * 60 * 60; // 2 days
    const rentalCompanyName = "XYZ Car Rentals";
    const userRetailerName = "John Doe";
    const companyLocation = "City, State, Country";
    const costPerDay = ethers.utils.parseEther("0.1");
    const additionalCosts = ethers.utils.parseEther("0.05");
    const batteryLife = 80;
    const batteryLevel = 60;
    const usableBatteryLevel = 50;
    const batteryRange = 150;

    await rentalContract.createRentalAgreement(
      receiptNumber,
      rentalDateTime,
      vinNumber,
      carInsuranceNumber,
      returnDateTime,
      rentalCompanyName,
      userRetailerName,
      companyLocation,
      costPerDay
    );

    await rentalContract.returnEVCar(
      receiptNumber,
      returnDateTime,
      additionalCosts,
      batteryLife,
      batteryLevel,
      usableBatteryLevel,
      batteryRange
    );

    const rentalAgreement = await rentalContract.getRentalAgreement(receiptNumber);

    expect(rentalAgreement.returnDateTime).to.equal(returnDateTime);
  });

  it("should get the EV car state", async () => {
    const vinNumber = "1ABC234DEF567GHI89";
    const batteryLife = 80;
    const batteryLevel = 60;
    const usableBatteryLevel = 50;
    const batteryRange = 150;

    await rentalContract.updateEVCarState(
      vinNumber,
      batteryLife,
      batteryLevel,
      usableBatteryLevel,
      batteryRange
    );

    const evCarState = await rentalContract.getEVCarState(vinNumber);

    expect(evCarState.batteryLife).to.equal(batteryLife);
    expect(evCarState.batteryLevel).to.equal(batteryLevel);
    expect(evCarState.usableBatteryLevel).to.equal(usableBatteryLevel);
    expect(evCarState.batteryRange).to.equal(batteryRange);
  });
});
