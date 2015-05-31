/* Optional app-specific JavaScript goes here */

// Initialize namespace for our own use:
RA.ux.cZoo = {};

RA.ux.cZoo.renderWeightChart = function(v) {

  var h = 150, w = 400;

  if(!v) {
    return [
      '<div class="no-chart-data-wrap" style="line-height:',(h-40),'px;height:',h,'px;width:',w,'px;">',
        '<div class="no-chart-data">',
        '<span class="ra-null-val"><i>No weight history</i></span>',
        '</div>',
      '</div>'
    ].join('');
  }

  var labels = [], values = [];
  var pairs = v.split(',');
  Ext.each(pairs,function(pair){
    var parts = pair.split('/');
    //labels.push(parts[0].split(' ')[0]);
    labels.push('');
    values.push(parts[1]);
  },this);
  
  var options = {};
  var data = {
      labels: labels,
      datasets: [
          {
              label: "Weight History",
              // ---
              // Blue:
              //fillColor: "rgba(151,187,205,0.2)",
              //strokeColor: "rgba(151,187,205,1)",
              //pointColor: "rgba(151,187,205,1)",
              // Red:
              fillColor   : "rgba(204,0,0,0.2)",
              strokeColor : "rgba(204,0,0,1)",
              pointColor  : "rgba(204,0,0,1)",
              // ---
              pointStrokeColor: "#fff",
              pointHighlightFill: "#fff",
              pointHighlightStroke: "rgba(151,187,205,1)",
              data: values
          }
      ]
  };  
    
  var render_chart = function(elId,data) {
    var ctx = document.getElementById(elId).getContext("2d");
    var myLineChart = new Chart(ctx).Line(data,options);
  };
  
  var id = ['weight-chart-',Math.floor(Math.random()*100000000)].join('');
  render_chart.defer(100,this,[id,data]);
  return['<canvas width="',w,'" height="',h,'" id="',id,'" class="weight-chart"></canvas>'].join('');
}



RA.ux.cZoo.imgRenderSpeciesBarChart = function(sData) {

  // We expect 'this' scope to be an <img> within the target <canvas> element
  var canvas = this.parentElement;
  
  if(canvas && canvas.tagName && canvas.tagName.toLowerCase() == 'canvas') {
  
    var labels = [], values = [], itmMap = {};
    Ext.each(sData,function(itm){
      labels.push(itm.name);
      values.push(itm.creatures);
      itmMap[itm.name] = itm;
    },this);
  
    var options = {};
    var data = {
        labels: labels,
        datasets: [
            {
                label: "SpeciesCounts",
                fillColor: "rgba(151,187,205,0.5)",
                strokeColor: "rgba(151,187,205,0.8)",
                highlightFill: "rgba(151,187,205,0.75)",
                highlightStroke: "rgba(151,187,205,1)",
                data: values
            }
        ]
    };
  
    var ctx = canvas.getContext("2d");
    var myBarChart = new Chart(ctx).Bar(data,options);

    canvas.onclick = function(evt) {
      var activeBars = myBarChart.getBarsAtEvent(evt);
      if(activeBars.length == 1) {
        var itm = itmMap[activeBars[0].label];
        var url = [
          Ext.ux.RapidApp.AJAX_URL_PREFIX || '', //<-- in case we're mounted somewhere
          '/main/db/db_species/item/',itm.id
          //,'/rel/creatures' //<-- if we wanted to link directly to the creature list
        ].join('');

        // perform the nav via hashpath:
        window.location.hash = '#!' + url;
      }
    };
  }
};
