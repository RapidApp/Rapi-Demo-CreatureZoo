### Cool dashboard goes here...

<br><br>

<h5>
  <a 
    class="with-icon icon-bugs-yellow"
    href="#!/creatures"
  >Creatures Listing (Custom DataView)</a>
</h5>

<h5>
  <a 
    class="with-inline-icon icon-bugs-yellow"
    href="#!/creature_grid"
  >Creature Grid (reference)</a>
</h5>

   
<div style="float:right;">
  <canvas height="250" width="400">
    <!-- here we're using an <img> tag so we can hijack its onload event -->
    <img 
      src="[% c.mount_url %]/assets/rapidapp/misc/static/s.gif" 
      onload='Ext.ux.CreatureZoo.imgRenderSpeciesBarChart.call(this,[% species_chart_data_json %])' 
    >
  </canvas>
</div>
