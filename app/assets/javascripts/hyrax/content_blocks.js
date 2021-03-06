Blacklight.onLoad(function() {
  // hide the editor initially
  $('[data-behavior="reveal-editor"]').each(function(){$($(this).data('target')).hide();});

  // Show the form, hide the preview
  $('[data-behavior="reveal-editor"]').on('click', function(evt) {
    evt.preventDefault();
    $this = $(this);
    $this.parent().hide();
    $($this.data('target')).show();
  });

  $('.show-confirm').on('click', function(evt) {
    evt.preventDefault();
    evt.stopPropagation();
    $('#change-tab-content-block').modal('show');
  });

  $('#change-tab-btn').on('click', function(evt) {
    evt.preventDefault();
    $('#change-tab-content-block').modal('hide');
    $('.nav-tabs a[href="' + location.hash + '"]').tab('show');
  });    
});