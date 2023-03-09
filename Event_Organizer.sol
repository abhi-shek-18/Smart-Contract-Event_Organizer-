//SPDX-License-Identifier: Unlicensed

pragma solidity >=0.8.0;

contract Events{
    struct Event{
         address organizer;   //event organizer address
         string name;    // Name of the Event
         uint date;  // Date of the Event
         uint price;  // Price of the ticket
         uint tickets;  //total tickets
         uint Tic_rem;   //tickets remaining
    } 
 //mapping is done so as to user can create no of events as per requirement
    mapping(uint => Event) public events;
    mapping(address => mapping(uint => uint)) public ticket;
    uint public nextid;   //id for next event

    function CreateEvent(string memory name,uint date,uint price,uint tickets) external{
        //first check date of the event must be greater than the present date
        require(date > block.timestamp,"You can Organize the event for Future dates");

        //then check the quantity of the tickets must be greater than 0
        require(tickets>0,"You can Organize Event only if you have atleast 1 ticket");

        events[nextid] = Event(msg.sender,name,date,price,tickets,tickets);  //this is for eventid=0
        nextid++;  //then increase the eventid
    }
//function for buying the tickets
    function buyTicket(uint Event_id,uint Ticket_Purchase) external payable{
        //first check the event exist or not
        require(events[Event_id].date!=0,"This Event Does not Exist");
        //secondly check if the  event already occurred 
        require(events[Event_id].date > block.timestamp,"Events already Occurred");

        Event storage _event= events[Event_id];  // this will point to the current event
        //Now check if the amount paid is equal to the total ticket money according to ticket purchase
        require(msg.value == (_event.price*Ticket_Purchase),"Ether is Not Enough");

        //and check if the tickets are available to sell
        require(_event.Tic_rem >= Ticket_Purchase,"Not Enough Tickets Available");

        _event.Tic_rem-=Ticket_Purchase;  //after the ticket purchased decrement the remaining ticket with that quantity

        //now using second mapping
      //ticket[John][1]+=4 ;  Event_id=1 may be a seminar event and 4 is the tickets purcahsed
        ticket[msg.sender][Event_id]+= Ticket_Purchase;
    }

    //function for transfering tickets to another person
    function SendTicket(uint Event_id,uint persons,address to)external{
         //first check the event exist or not
        require(events[Event_id].date!=0,"This Event Does not Exist");
        //secondly check if the  event already occurred 
        require(events[Event_id].date > block.timestamp,"Events already Occurred");

        //now check if the ticket quantity is equal to or less than the no of person to be transfered for
        require(ticket[msg.sender][Event_id]>=persons,"You don't have Enough Tickets");

        ticket[msg.sender][Event_id]-=persons;  //transfered tickets
        ticket[to][Event_id]+=persons;      //added that events tickets to the persons id

    }
}
