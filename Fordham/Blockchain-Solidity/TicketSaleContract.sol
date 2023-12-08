// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;
contract TicketSaleContract {
 
uint8 public total_events;
 event EventConfirmation(uint eventID, uint total_tickets, uint ticket_price, address event_woner);
 
struct Event {
 
uint eventID;
uint tickets_available;
uint tickets_sold;
address event_owner;
uint ticket_price;
}
 
struct Ticket {
    uint eventID;
    uint ticketID;
    address ticket_owner;
    uint ticket_price;
    bool for_sale; 
    }
mapping(uint => Event) public events; // list of all events
mapping(uint => mapping(address => Ticket)) public tickets; // registry of events' tickets and attendees
constructor(){
    total_events = 0; // initialize total_events
    }
 
function create_event (uint total_tickets, uint ticket_price) public {
 
require(total_tickets > 0 && ticket_price >= 0, "Total number of tickets must be > 0 and the price must be positive");
total_events += 1;
events[total_events] = Event({ //create new event
eventID: total_events,
tickets_available: total_tickets,
tickets_sold: 0,
event_owner: msg.sender,
ticket_price: ticket_price
});
 
emit EventConfirmation(events[total_events].eventID, events[total_events].tickets_available,
events[total_events].ticket_price, events[total_events].event_owner);
 
}
 
function buy_from_organizer (uint eventID) public payable{
    require(events[eventID].eventID == eventID, "This event is not available");
    require(events[eventID].tickets_available > 0, "The organizer does not have more tickets available");
    require(events[eventID].ticket_price <= msg.value, "You don't have enough balance to buy this ticket");
    events[eventID].tickets_available -= 1;
    events[eventID].tickets_sold += 1;
    tickets[eventID][msg.sender] = Ticket({ // generate ticket
    eventID: eventID,
    ticketID: events[eventID].tickets_sold,
    ticket_owner: msg.sender,
    ticket_price: events[eventID].ticket_price,
    for_sale: false
    });
    
    payable(events[eventID].event_owner).transfer(events[eventID].ticket_price); // pay event owner/organizer
    
    uint refund = msg.value - events[eventID].ticket_price; // refund extra money
    if (refund > 0) {
        payable(msg.sender).transfer(refund);
        }
}
 
function sell_ticket_on_secondary_mkt(uint eventID,uint selling_price) public { // sell ticket on P2P way
    require(events[eventID].event_owner != msg.sender, "You are the event owner, you can't sell on the secondary market");
    require(tickets[eventID][msg.sender].ticket_owner == msg.sender, "You're not the ticket owner");
    tickets[eventID][msg.sender].for_sale = true;
    tickets[eventID][msg.sender].ticket_price = selling_price;
    }
 
function buy_ticket_on_secondary_mkt(uint eventID, address seller_address) payable public {
    require(tickets[eventID][seller_address].ticketID != 0, "There is no ticket avaiable");
    require(tickets[eventID][seller_address].for_sale, "The ticket is not for sale");
    require(tickets[eventID][seller_address].ticket_price <= msg.value);
    payable(tickets[eventID][seller_address].ticket_owner).transfer(tickets[eventID][msg.sender].ticket_price); //pay seller
    
    tickets[eventID][seller_address].for_sale = false; // ticket is no more for sale
    tickets[eventID][msg.sender] = tickets[eventID][seller_address]; // create new version of ticket w/ new owner
    delete tickets[eventID][seller_address]; // remove old version of ticket
    uint refund = msg.value - events[eventID].ticket_price; // refund extra money
    if (refund > 0) {
    payable(msg.sender).transfer(refund);
    }
}
 
function validate_attendee (uint eventID, address attendee) public view returns (uint8) { // check attendee and event on array
    require(events[eventID].eventID == eventID, "Event does not exist");
    require(tickets[eventID][attendee].eventID != 0, "Attendee is not in the list");
    return 1;
    }
}