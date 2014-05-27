var Filter = Filter || {
  ui: {
    by_value: null,
    by_type: null,
  },
  by_value: null,
  by_type: null
};

$(document).on('ready', function() {
  Filter.ui.by_value = $('#filter_by_value').chosen();
  Filter.ui.by_type = $('#filter_by_type');

  Filter.by_value = Filter.ui.by_value.val();
  Filter.by_type = Filter.ui.by_type.val();

  Filter.ui.by_value.change(function() {
    Filter.by_value = $(this).val();

    var data = {};
    data['layout'] = 'yes'
    data[Filter.by_type + '_id'] = Filter.by_value;

    if (Filter.by_type !== '' && Filter.by_value !== '') {
      $.get('/dashboard/by_' + Filter.by_type, data).done(function(response) {
        $('#charts_container').html(response);
      });
    }
  });

  Filter.ui.by_type.change(function() {
    Filter.by_type = $(this).val();
    Filter.by_value = '';
    var newValues;

    switch(Filter.by_type) {
      case 'company':
        newValues = $.map(Filter.companies, function(item) {
          return '<option value="' + item + '">' + item + '</option>';
        }).join('');
      break;
      case 'project':
        newValues = $.map(Filter.projects, function(item) {
          return '<option value="' + item[1] + '">' + item[0] + '</option>';
        }).join('');
      break;
    }

    Filter.ui.by_value.html(newValues).trigger('chosen:updated');
  });
});