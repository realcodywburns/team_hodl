// Timelock
// lock withdrawal for a set time period
// @authors:
// Cody Burns <dontpanic@codywburns.com>
// license: Apache 2.0
// version:

pragma solidity ^0.4.11;

// Intended use: lock withdrawal for a set time period
//
// Status: functional
// still needs:
// submit pr and issues to https://github.com/realcodywburns/
//version 0.2.0


contract timelock {

////////////////
//Global VARS//////////////////////////////////////////////////////////////////////////
//////////////

    uint public freezeBlocks = 2000000;       //number of blocks to keep a lockers (5)

///////////
//MAPPING/////////////////////////////////////////////////////////////////////////////
///////////

    struct locker{
      uint freedom;
      uint bal;
    }
    mapping (address => locker) public lockers;

///////////
//EVENTS////////////////////////////////////////////////////////////////////////////
//////////

    event Locked(address indexed locker, uint indexed amount);
    event Released(address indexed locker, uint indexed amount);

/////////////
//MODIFIERS////////////////////////////////////////////////////////////////////
////////////

//////////////
//Operations////////////////////////////////////////////////////////////////////////
//////////////

/* public functions */
    function() payable public {
        locker storage l = lockers[msg.sender];
        l.freedom =  block.number + freezeBlocks; //this will reset the freedom clock
        l.bal = l.bal + msg.value;

        Locked(msg.sender, msg.value);
    }

    function withdraw() public {
        locker storage l = lockers[msg.sender];
        require (block.number > l.freedom && l.bal > 0);

        // avoid recursive call

        uint value = l.bal;
        l.bal = 0;
        msg.sender.transfer(value);
        Released(msg.sender, value);
    }

////////////
//OUTPUTS///////////////////////////////////////////////////////////////////////
//////////

////////////
//SAFETY ////////////////////////////////////////////////////////////////////
//////////


}

/////////////////////////////////////////////////////////////////////////////
// 88888b   d888b  88b  88 8 888888         _.-----._
// 88   88 88   88 888b 88 P   88   \)|)_ ,'         `. _))|)
// 88   88 88   88 88`8b88     88    );-'/             \`-:(
// 88   88 88   88 88 `888     88   //  :               :  \\   .
// 88888P   T888P  88  `88     88  //_,'; ,.         ,. |___\\
//    .           __,...,--.       `---':(  `-.___.-'  );----'
//              ,' :    |   \            \`. `'-'-'' ,'/
//             :   |    ;   ::            `.`-.,-.-.','
//     |    ,-.|   :  _//`. ;|              ``---\` :
//   -(o)- (   \ .- \  `._// |    *               `.'       *
//     |   |\   :   : _ |.-  :              .        .
//     .   :\: -:  _|\_||  .-(    _..----..
//         :_:  _\\_`.--'  _  \,-'      __ \
//         .` \\_,)--'/ .'    (      ..'--`'          ,-.
//         |.- `-'.-               ,'                (///)
//         :  ,'     .            ;             *     `-'
//   *     :         :           /
//          \      ,'         _,'   88888b   888    88b  88 88  d888b  88
//           `._       `-  ,-'      88   88 88 88   888b 88 88 88   `  88
//            : `--..     :        *88888P 88   88  88`8b88 88 88      88
//        .   |           |	        88    d8888888b 88 `888 88 88   ,  `"	.
//            |           | 	      88    88     8b 88  `88 88  T888P  88
/////////////////////////////////////////////////////////////////////////
