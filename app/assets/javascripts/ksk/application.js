//= require_tree ./classes

initHelper(function(scope){
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

	scope.getElements('.assets_list').each(function(elem){
		new Sortables(elem, {
			handle: '.handle',
			onStart: function(element, clone){
				element.addClass('dragged');
			},
			onComplete: function(element){
				element.removeClass('dragged');
				new Request({
					method: 'put',
					url: this.element.getParent('ol').get('data-sort-url')
				}).send({data: {order: this.serialize()}});
			}
		});
	});
});
