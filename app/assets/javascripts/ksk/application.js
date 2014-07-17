//= require_tree ./classes

window.addEvent('bhfDomChunkReady', function(scope){
  
	scope.getElements('.js_tree_holder').each(function(elem){
		var naviA = new NaviAdmin({
			elemTree: elem.getElement('.js_tree_list'),
			onItemDropped: function(item, parent, itemId, parentId){
				var queryParams = {
					'_method': 'put',
					id: itemId,
					parent_id: parentId
				};
				queryParams[this.getNaviName()] = this.getIdPositions();
				new Request({
					url: elem.get('data-update-url')
				}).post(queryParams);
			}
		});
		var platform = elem.getParent('.platform');
		platform.getElements('.create a').addEvent('click', function(e){
			e.preventDefault();
			var tmpl = platform.getElement('.template_data');
			var name = prompt(tmpl.get('data-prompt-question'), '');
			if ( ! name) { return; }
			var naviName = naviA.getNaviName();
			var queryParams = {};
			queryParams[naviName] = {
				title: name
			};
			new Request({
				url: platform.getElement('.template_data').get('data-update-path'),
				onSuccess: function(responseText){
					new Element('li', {
					  'id': naviName+'_'+responseText,
					  'html': '<div> <span class="title">'+name+'</span> <span class="links">'+tmpl.get('html')+'</span></div>'.replace(/NAVIID/g, responseText)
					})
					.inject(platform.getElement('.js_tree_list li'), 'before');
					naviA.reInit();
				}
			}).post(queryParams);
		});
	});	
	
	cropImages = scope.getElements('.js_crop_image');
	if (cropImages.length) {
		var cropInit = function(){
			$.noConflict();
			jQuery('.js_crop_image', scope).each(function(){
				var $cropImg = jQuery(this);
				var minWidth, minHeight;
				var styleGeo = $cropImg.attr('data-crop-style') || '';
				var styleGeoArray = styleGeo.split('x');
				if (styleGeoArray.length === 2) {
					if ( ! styleGeo.match('<') && ! styleGeo.match('>')) {
						minWidth  = parseInt(styleGeoArray[0], 10);
						minHeight = parseInt(styleGeoArray[1], 10);
					}
				}
				var hasSize = minWidth && minHeight;
				
				$cropImg.Jcrop({
					// minSize:  (hasSize ? [minWidth, minHeight]  : undefined),
					aspectRatio: (hasSize ? (minWidth / minHeight) : undefined),
					boxWidth:    800,
					boxHeight:   800,
					onSelect: function(c){
						$cropImg.parent().find('.js_cords_x').val(c.x);
						$cropImg.parent().find('.js_cords_y').val(c.y);
						$cropImg.parent().find('.js_cords_w').val(c.w);
						$cropImg.parent().find('.js_cords_h').val(c.h);
					}
				});
			});
		};
		Asset.css('http://jcrop-cdn.tapmodo.com/v0.9.12/css/jquery.Jcrop.min.css', {
			onLoad: function(){
				Asset.javascript('http://edge1u.tapmodo.com/global/js/jquery.min.js', {
					onLoad: function(){
						Asset.javascript('http://jcrop-cdn.tapmodo.com/v0.9.12/js/jquery.Jcrop.min.js', {
							onLoad: cropInit
						});
					}
				});
			}
		});
	}
	
});
