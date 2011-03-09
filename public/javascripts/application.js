$(function(){
  // Open the invite form when a share button is clicked
  $('.share a').click(function(){
    var $this = $(this), folderName = $this.data('folder-name'), folderID = $this.data('folder-id'), $invitationForm = $('#invitation_form');
    
    // Put the folder_id of the share link in to the hidden filed "folder_id" of the invite form
    $('#folder_id').val(folderID);
    
    // Add the dialog box here
    $invitationForm.dialog({
      height: 300,
      width: 600,
      modal: true,
      buttons: {
        // First button
        "Share": function(){
          // get the url to post the form data to
          var post_url = $invitationForm.find('form').attr('action');
          
          // Serialize the form data and post it to the url with ajax
          $.post(post_url, $invitationForm.find('form').serialize(), null, "script");
          
          return false;
        },
        // Second button
        "Cancel": function(){
          $(this).dialog("close");
        }
      },
      close: function(){
        // close function
      }
    });

    // Set the title of the dialog box
    $invitationForm.data('title', "Share '" + folderName + "' with others");
    $('#ui-dialog-title-invitation_form').text("Share '" + folderName + "' with others");
    
    return false;
  });
});