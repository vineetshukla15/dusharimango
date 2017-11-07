//if (lookup_table.hasOwnProperty(ad_str) )


//process first file
var file_process_done = 0;

var spendHash  = {};
var first_file  = process.argv[2];
if (!first_file ) {
   console.log ("Usage: program first_file");
   process.exit(0);
}

function process_first_file()
{

   var fs = require('fs'),
       readline = require('readline');
   var rd = readline.createInterface({
       input: fs.createReadStream(first_file),
       output: process.stdout,
       terminal: false
   });

   rd.on('line', function(line) {
     var this_line = line;
     //console.log("_DBG processing this_line: " + this_line);
     //2016-01-01 00:00:03     2623362 FEMA Ready.gov Commercial       FEMA    876     14886   EncrFmly        Maleficent      Fantasy MV004991580000
//airing_time     content_id      title   brand   brand_id        stations_id     network show_name       show_genre      show_tmsid

     var res = this_line.split('\t');
     var key = res[0] + '|' + res[1] + '|' + res[4] + '|' + res[5] + '|' + res[9] ;
     var spend = res[13];
     //console.log ('DBG key:' + key  + 'spend:' + spend);
     spendHash[key] = spend;

   });

   rd.on('close', function() {
      //set flag
      file_process_done = 1;
      //process.exit(0);
   });

}

function process_stdin()
{

   var fs = require('fs'),
       readline = require('readline');
   var rd = readline.createInterface({
       input: process.stdin,
       output: process.stdout,
       terminal: false
   });

   rd.on('line', function(line) {
     var this_line = line;
     //console.log("_DBG1 processing this_line: " + this_line);
     var res = this_line.split('\t');
     var key = res[0] + '|' + res[1] + '|' + res[4] + '|' + res[5] + '|' + res[9] ;
     //var new_spend = res[10]; //def old spend
     var new_spend = 0; //def to zero
     if (spendHash.hasOwnProperty(key) ) {
        new_spend = spendHash[key];
      
     }
     //console.log ('DBG 1 key:' + key + ' new_spend:' + new_spend);
     res[10] =  new_spend;
     var mod_line = '';
     for (var idx = 0; idx < res.length; idx ++ ) {
        if (idx !=0 ) {
           mod_line += '\t';
        }
        mod_line += res[idx];
     }
     console.log ( mod_line);

   });

   rd.on('close', function() {
      //set flag
      process.exit(0);
   });


}


// main
process_first_file();
proces_block();

//end
function proces_block()
{
   if (file_process_done != 1 ) {
      setTimeout ( proces_block, 100);
      return;
   }

   //console.log ('DBG I am here');
   process_stdin();

}

