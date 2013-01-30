package hw2013PD.plugins.problems.PD.controller
{
	import collaboRhythm.plugins.schedule.shared.model.IHealthActionInputController;
	import collaboRhythm.plugins.schedule.shared.model.IHealthActionInputModel;
	import collaboRhythm.plugins.schedule.shared.model.IHealthActionModelDetailsProvider;
	import collaboRhythm.plugins.schedule.shared.model.IScheduleCollectionsProvider;
	import collaboRhythm.shared.model.healthRecord.document.ScheduleItemOccurrence;

	import flash.events.MouseEvent;

	import flash.net.URLVariables;

	import hw2013PD.plugins.problems.PD.model.TremoCupModel;

	import spark.components.ViewNavigator;

	public class TremoCupHealthActionInputController implements IHealthActionInputController
	{
		private var _tremoCupModel:TremoCupModel;
		private var _viewNavigator:ViewNavigator;

		public function TremoCupHealthActionInputController(scheduleItemOccurrence:ScheduleItemOccurrence,
															healthActionModelDetailsProvider:IHealthActionModelDetailsProvider,
															scheduleCollectionsProvider:IScheduleCollectionsProvider,
															viewNavigator:ViewNavigator)
		{
			_tremoCupModel = new TremoCupModel();
			_viewNavigator = viewNavigator
		}

		public function handleHealthActionResult(initiatedLocally:Boolean):void
		{
		}

		public function handleHealthActionSelected():void
		{
		}

		public function handleUrlVariables(urlVariables:URLVariables):void
		{
		}

		public function get healthActionInputViewClass():Class
		{
			return null;
		}

		public function useDefaultHandleHealthActionResult():Boolean
		{
			return false;
		}

		public function updateDateMeasuredStart(date:Date):void
		{
		}

		public function handleHealthActionCommandButtonClick(event:MouseEvent):void
		{
		}

		public function removeEventListener():void
		{
		}

		public function handleAdherenceChange(dataInputModel:IHealthActionInputModel,
											  scheduleItemOccurrence:ScheduleItemOccurrence, selected:Boolean):void
		{
		}

		public function get isReview():Boolean
		{
			return false;
		}

		public function get model():TremoCupModel
		{
			return _tremoCupModel;
		}
	}
}
