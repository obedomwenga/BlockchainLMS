// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CourseEnrollment {
    struct Course {
        uint256 price;
        address payable creator;
        bool isActive;
    }

    // Define a state variable for the platform's fee percentage
    uint256 public platformFeePercentage = 10;

    // Define an address for the platform's funds
    address payable public platformWallet;

    // Set the platform's wallet address during contract deployment
    constructor(address payable _platformWallet) {
        platformWallet = _platformWallet;
    }
    

    mapping(uint256 => Course) public courses;
    mapping(address => mapping(uint256 => bool)) public enrollments; // Tracks user enrollments

    function createCourse(uint256 _courseId, uint256 _price) public {
        require(_price > 0, "Price must be greater than 0");
        courses[_courseId] = Course(_price, payable(msg.sender), true);
    }

    function enrollInCourse(uint256 _courseId) public payable {
        Course storage course = courses[_courseId];
        require(course.isActive, "Course is not active.");
        require(msg.value >= course.price, "Insufficient payment.");

        // Calculate the platform's fee
        uint256 platformFee = msg.value * platformFeePercentage / 100;
        
        // Calculate the creator's revenue
        uint256 creatorRevenue = msg.value - platformFee;

        // Transfer the platform's fee to the platform's wallet
        platformWallet.transfer(platformFee);

        // Transfer the remainder to the course creator
        course.creator.transfer(creatorRevenue);

        enrollments[msg.sender][_courseId] = true; // Mark as enrolled
    }

    // Additional functions and contract logic...
}
