package hw2013PD.plugins.problems.PD.controller
{
	import collaboRhythm.plugins.schedule.shared.model.IHealthActionInputModel;
	import collaboRhythm.plugins.schedule.shared.model.IHealthActionModelDetailsProvider;
	import collaboRhythm.plugins.schedule.shared.model.IScheduleCollectionsProvider;
	import collaboRhythm.shared.model.healthRecord.document.ScheduleItemOccurrence;

	import flash.events.MouseEvent;

	import flash.net.URLVariables;

	import hw2013PD.plugins.problems.PD.model.RehabilitationGloveSessionModel;
	import hw2013PD.plugins.problems.PD.view.RehabilitationGloveSessionView;

	import spark.components.ViewNavigator;

	import collaboRhythm.plugins.schedule.shared.model.IHealthActionInputController;

	public class RehabilitationGloveSessionHealthActionInputController implements IHealthActionInputController
	{
		private var _rehabilitationGloveSessionModel:RehabilitationGloveSessionModel;
		private var _viewNavigator:ViewNavigator;

		public function RehabilitationGloveSessionHealthActionInputController(scheduleItemOccurrence:ScheduleItemOccurrence,
																			 healthActionModelDetailsProvider:IHealthActionModelDetailsProvider,
																			 scheduleCollectionsProvider:IScheduleCollectionsProvider,
																			 viewNavigator:ViewNavigator)
		{
			_rehabilitationGloveSessionModel = new RehabilitationGloveSessionModel();
			_viewNavigator = viewNavigator
		}

		public function handleHealthActionResult(initiatedLocally:Boolean):void
		{
			_viewNavigator.pushView(RehabilitationGloveSessionView, this);
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

		public function get model():RehabilitationGloveSessionModel
		{
			return _rehabilitationGloveSessionModel;
		}
	}
}
