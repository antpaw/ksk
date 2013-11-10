//= require_tree ./classes

var kskInit = function(){
	$$('.js_tree_holder').each(function(elem){
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
					url: '#{sort_ksk_navigations_path}'
				}).post(queryParams);
			}
		});
		$$('#navigation_platform .create a').addEvent('click', function(e){
			e.preventDefault();
			var tmpl = elem.getElement('.template_data');
			var name = prompt(tmpl.get('data-prompt-question'), '');
			if ( ! name) { return; }

			var naviName = naviA.getNaviName();
			var queryParams = {};
			queryParams[naviName] = {
				title: name
			};
			new Request({
				url: elem.getElement('.template_data').get('data-update-path'),
				onSuccess: function(responseText){
					new Element('li', {
					  'id': naviName+'_'+responseText,
					  'html': '<div> <span class="title">'+name+'</span> <span class="links">'+tmpl.get('html')+'</span></div>'.replace(/NAVIID/g, responseText)
					})
					.inject($('tree').getElement('li'), 'before');
					naviA.reInit();
				}
			}).post(queryParams);
		});
	});

	$$('.assets_list').each(function(elem){
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
};

window.addEvent('domready', kskInit);

if (document.addEventListener) {
	document.addEventListener('page:load', kskInit);
}
