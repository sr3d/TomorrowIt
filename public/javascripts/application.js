function showForgotPassword() { 
  $('forgot_password_wrapper').show();
  new Effect.Highlight( 'forgot_password_wrapper', { duration: 0.3 } );
}

function toggleForgotPasswordForm()
{
  if( $('forgot_password_form_wrapper').visible() )
    $('forgot_password_form_wrapper').hide();
  else
    Effect.BlindDown('forgot_password_form_wrapper', { duration: 0.3 });
  return false
}  

function checkForEmptyTasks()
{
  if( ( $('today_tasks_wrapper').select( ".today_item_wrapper") ).length == 0 )
    $('today_empty').show();
  else
    $('today_empty').hide();
    
    
  if( ( $('tomorrow_tasks_wrapper').select( ".tomorrow_item_wrapper") ).length == 0 )
    $('tomorrow_empty').show();
  else
    $('tomorrow_empty').hide();
}