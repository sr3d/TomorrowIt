function showForgotPassword() { 
  $('forgot_password_wrapper').show();
  new Effect.Highlight( 'forgot_password_wrapper', { duration: 0.3 } );
}

function toggleForgotPasswordForm()
{
  if( $('forgot_password_form_wrapper').visible() )
    $('forgot_password_form_wrapper').hide();
  else
    Effect.BlindDown('forgot_password_form_wrapper', { duration: 0.3 } );
  return false
}  

function checkForEmptyTasks()
{
  if( $('today_tasks_wrapper').down( ".today_item_wrapper") )
  {
    $('today_empty').hide();
  }
  else
  {
    $('today_empty').show();
  } 
    
  if( $('tomorrow_tasks_wrapper').down( ".tomorrow_item_wrapper" ) )
  {
    $('tomorrow_empty').hide();
  }
  else
  {
    $('tomorrow_empty').show();
  }
};

function textboxToggleValue( element, defaultValue ) {
  element = $( element );
  defaultValue = defaultValue.strip();
  if ( element.value.blank() ) 
  {
    element.value = defaultValue;
  }
  
  var onFocus = function() { 
    if( element.value.strip() == defaultValue ) 
      element.value = ''; 
  }
  var onBlur = function() {
    if( element.value.blank() ) 
      element.value = defaultValue; 
  }
  element.observe('focus', onFocus ).observe( 'blur', onBlur );
}

// window.currentChainTaskId =  '';
var ChainTask = { 
  toggleDate: function( element, date ) {
    if( !this.getCurrentChainTaskId() ) return;
    
    element = $(element);
    new Ajax.Request( '/chain_tasks/toggle_date', { 
      parameters: { date: date, id: this.getCurrentChainTaskId(), authenticity_token: window._token }
      ,onSuccess: function(){ element.toggleClassName('has_items') }
    } );
  }
  ,selectTask: function( element, chainTaskId ) {
    element = $(element);
    
    if( window.currentChainTaskId == chainTaskId )
      return;
    
      window.currentChainTaskId = chainTaskId;
      element.toggleClassName( 'current' );
      new Ajax.Request( '/chain_tasks/toggle_date', { 
        parameters: { date: date, id: this.getCurrentChainTaskId }
        ,onSuccess: function(){ element.toggleClassName('has_items') }
      } );   
  }
  
  ,getCurrentChainTaskId: function() { 
    return window.currentChainTaskId;
  }
};
