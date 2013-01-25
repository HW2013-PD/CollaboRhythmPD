package hw2013PD.plugins.problems.PD.controller
{
	import castle.flexbridge.reflection.ReflectionUtils;

	import collaboRhythm.plugins.schedule.shared.model.IHealthActionCreationControllerFactory;
	import collaboRhythm.plugins.schedule.shared.model.IHealthActionInputControllerFactory;
	import collaboRhythm.plugins.schedule.shared.model.IHealthActionListViewAdapterFactory;
	import collaboRhythm.shared.controller.apps.AppControllerInfo;
	import collaboRhythm.shared.model.services.IComponentContainer;
	import collaboRhythm.shared.pluginsSupport.IPlugin;
	import collaboRhythm.shared.ui.healthCharts.model.modifiers.IChartModifierFactory;

	import hw2013PD.plugins.problems.PD.model.PDHealthActionInputControllerFactory;

	import hw2013PD.plugins.problems.PD.model.PDHealthActionListViewAdapterFactory;

	import mx.modules.ModuleBase;

	public class PDPluginModule extends ModuleBase implements IPlugin
	{
		public function PDPluginModule()
		{
			super();
		}

		public function registerComponents(componentContainer:IComponentContainer):void
		{
			// TODO: each plugin should register one or more of the following components; implement or delete the code below as appropriate; using the CollaboRhythm file templates in IntelliJ IDEA may make this easier
			componentContainer.registerComponentInstance(ReflectionUtils.getClassInfo(PDAppController).name,
					AppControllerInfo,
					new AppControllerInfo(PDAppController));

			componentContainer.registerComponentInstance(ReflectionUtils.getClassInfo(PDHealthActionListViewAdapterFactory).name,
					IHealthActionListViewAdapterFactory,
					new PDHealthActionListViewAdapterFactory());

			componentContainer.registerComponentInstance(ReflectionUtils.getClassInfo(PDHealthActionInputControllerFactory).name,
					IHealthActionInputControllerFactory,
					new PDHealthActionInputControllerFactory());

//			componentContainer.registerComponentInstance(ReflectionUtils.getClassInfo(PDChartModifierFactory).name,
//					IChartModifierFactory,
//					new PDChartModifierFactory());
//
//			componentContainer.registerComponentInstance(ReflectionUtils.getClassInfo(PDHealthActionCreationControllerFactory).name,
//					IHealthActionCreationControllerFactory,
//					new PDHealthActionCreationControllerFactory());
		}
	}
}
