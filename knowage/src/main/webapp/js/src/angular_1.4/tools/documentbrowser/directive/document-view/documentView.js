(function() {
	var scripts = document.getElementsByTagName("script");
	var currentScriptPath = scripts[scripts.length - 1].src;
	currentScriptPath = currentScriptPath.substring(0, currentScriptPath.lastIndexOf('/') + 1);
	
angular.module('document_view', ['ngMaterial','sbiModule'])
.directive('documentView', function() {
	return {
//		templateUrl: '/knowage/js/src/angular_1.4/tools/documentbrowser/directive/document-view/document-view.jsp',
		 templateUrl: currentScriptPath + '/document-view.jsp',
		controller: documentViewControllerFunction,
		replace:true,
		 priority: 10,
		scope: {
			ngModel:"=",
			showGridView:"=?",
			tableSpeedMenuOption:"=?",
			selectedDocument:"=?",
			selectDocumentAction:"&",
			editDocumentAction:"&",
			cloneDocumentAction:"&",
			deleteDocumentAction:"&",
			executeDocumentAction:"&",
			orderingDocumentCards:"=?",
			firstInitialSorting:"=?",
		},
		link: function (scope, elem, attrs) { 
		 
			elem.css("margin","0px");
			 if(!attrs.tableSpeedMenuOption){
				 scope.tableSpeedMenuOption=[];
			 }
		}
	}
});

function documentViewControllerFunction($scope,sbiModule_config, sbiModule_translate){
	$scope.translate = sbiModule_translate;
	$scope.sbiModule_config=sbiModule_config;
	$scope.clickDocument=function(item){
		$scope.selectDocumentAction({doc: item});
	}
}
})();