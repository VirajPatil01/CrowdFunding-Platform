// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CrowdFunding {
    struct Campaign {
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 amoutCollected;
        string image;
        address[] donators;
        uint256[] donations;
    }

    //we an simply acess by array accesing in javascript but not in solidity
    //we have to use mapping in solidity

    mapping(uint256 => Campaign) public campaigns;

    uint256 public numberOfCampaigns = 0;

    //memory tells Solidity to create a chunk of space for the variable at runtime, guaranteeing its size and structure for future use in that function during the function execution

    function createCampaign(
        address _owner,
        string memory _title,
        string memory _description,
        uint _target,
        uint _deadline,
        string memory _image
    ) public returns (uint256) {
        Campaign storage campaign = campaigns[numberOfCampaigns];

        //require is used for the checking of everything is ok or not and if not then it cannot proceed further.

        require(
            campaign.deadline < block.timestamp,
            "deadline should be a date in future"
        );

        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _description;
        campaign.target = _target;
        campaign.deadline = _deadline;
        campaign.image = _image;

        numberOfCampaigns++;

        return numberOfCampaigns - 1;
    }

    //payable keyword-----> payable keyword is suggesting that we passed currency through htid function

    function donateToCampaign(uint256 _id) public payable {
        //msg.value is used to get value from frontend
        uint256 amount = msg.value;
        Campaign storage campaign = campaigns[_id];

        campaign.donators.push(msg.sender);
        campaign.donations.push(amount);

        (bool sent, ) = payable(campaign.owner).call{value: amount}("");

        if (sent) {
            campaign.amoutCollected = campaign.amoutCollected + amount;
        }
    }

    function getDonators(
        uint256 _id
    ) public view returns (address[] memory, uint256[] memory) {

        return (campaigns[_id].donators,campaigns[_id].donations);

    }



    function getCampaigns() public view returns (Campaign[] memory){

        Campaign[] memory allCampaigns=new Campaign[](numberOfCampaigns);

        for(uint i=0; i<numberOfCampaigns; i++){
            Campaign storage item=campaigns[i];

            allCampaigns[i]=item;
        }
        return allCampaigns;
    }
}
