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
  toggleEnableChainTasks: function( element ) { 
    if( this.isTogglingDate ) { return; }

    element = $(element);
    if( !element.checked && !confirm("are you sure?") )
      return;
    new Ajax.Request( '/chain_tasks/toggle_chain_task_feature', { 
      parameters: { authenticity_token: window._token }
      ,onSuccess: function(){    }
      ,onCreate: function() { ChainTask.isTogglingDate = true; }
      ,onComplete: function() { ChainTask.isTogglingDate = false;
        element.blur();
      }
    } );      
    
  }
  
  ,toggleDate: function( element, date ) {
    if( this.isTogglingDate ) { return; }
    
    chainTaskId = this.getCurrentChainTaskId();
    element = $(element);
    new Ajax.Request( '/chain_tasks/toggle_date', { 
      parameters: { date: date, id: chainTaskId, authenticity_token: window._token }
      ,onSuccess: function(){ element.toggleClassName('has_items').toggleClassName('chain_task_' + chainTaskId ); }
      ,onCreate: function() { ChainTask.isTogglingDate = true; }
      ,onComplete: function() { ChainTask.isTogglingDate = false; }
    } );
  }
  ,selectChainTask: function( element, chainTaskId ) {
    element = $(element);
    
    if( window.currentChainTaskId == chainTaskId )
      return;
    
      window.currentChainTaskId = chainTaskId;
      element.toggleClassName( 'current' );
      new Ajax.Request( '/chain_tasks/get_calendar', { 
        parameters: { id: chainTaskId, authenticity_token: window._token }
        ,onSuccess: function(){ element.toggleClassName('current') }
      } );   
  }
  
  ,getCurrentChainTaskId: function() { 
    return window.currentChainTaskId;
  }
  
  ,selectChainTaskColor: function(element, chainTaskId ) {
    if( !$('toggle_chain_' + chainTaskId ).checked ) {
      Effect.Shake( $('toggle_chain_' + chainTaskId ), {
        duration: 0.3, distance: 2});
      //new Effect.Highlight( $('toggle_chain_' + chainTaskId), { duration: 0.3 } );
      return;
    }
    element = $(element);
    var wrapper = element.up('.chain_wrapper');
    var currentColor = wrapper.getAttribute('color');
    var selectedColor = element.getAttribute('color');
    if( currentColor == selectedColor )
      return;
      
    console.log( 'setting new color ' + selectedColor )  ;
    new Ajax.Request( '/chain_tasks/color', { 
      parameters: { 
        authenticity_token: window._token
        ,color: selectedColor
        ,id: chainTaskId
      }
      ,onSuccess: function(response) { 
        $('chain_task_name_' + chainTaskId ).style.backgroundColor = "#" + selectedColor;
        wrapper.setAttribute('color', selectedColor);
        element.blur();
      }
    } );
  }
};
