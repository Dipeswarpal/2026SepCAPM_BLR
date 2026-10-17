sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"application/project1/test/integration/pages/PurchaseOrderSrvList.gen",
	"application/project1/test/integration/pages/PurchaseOrderSrvObjectPage.gen"
], function (JourneyRunner, PurchaseOrderSrvListGenerated, PurchaseOrderSrvObjectPageGenerated) {
    'use strict';

    const runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('application/project1') + '/test/flp.html#app-preview',
        pages: {
			onThePurchaseOrderSrvListGenerated: PurchaseOrderSrvListGenerated,
			onThePurchaseOrderSrvObjectPageGenerated: PurchaseOrderSrvObjectPageGenerated
        },
        async: true
    });

    return runner;
});

