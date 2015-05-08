<?php

// Get lap receives a query from the frontend to change the lap.
function get_id() {
  global $id;
  // If we supply an id we have got all points up till that id.
  if(isset($_GET['id'])) {
    $id = intval($_GET['id']);
  }
}

// Get lap receives a query from the frontend to change the lap.
function get_lap() {
  global $lap;
  // If we supply an lap we have got all points up till that lap.
  if(isset($_GET['lap'])) {
    $lap = intval($_GET['lap']);
  }
}

?>
