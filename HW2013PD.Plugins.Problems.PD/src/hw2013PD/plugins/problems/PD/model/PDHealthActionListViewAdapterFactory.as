package hw2013PD.plugins.problems.PD.model
{
	import collaboRhythm.plugins.schedule.shared.model.IHealthActionListViewAdapter;
	import collaboRhythm.plugins.schedule.shared.model.IHealthActionListViewAdapterFactory;
	import collaboRhythm.plugins.schedule.shared.model.IHealthActionModelDetailsProvider;
	import collaboRhythm.shared.model.healthRecord.document.HealthActionPlan;
	import collaboRhythm.shared.model.healthRecord.document.HealthActionSchedule;
	import collaboRhythm.shared.model.healthRecord.document.ScheduleItemOccurrence;

	import mx.collections.ArrayCollection;

	public class PDHealthActionListViewAdapterFactory implements IHealthActionListViewAdapterFactory
	{

		public function PDHealthActionListViewAdapterFactory()
		{
		}

		public function createUnscheduledHealthActionViewAdapters(healthActionModelDetailsProvider:IHealthActionModelDetailsProvider,
		adapters:ArrayCollection):void
		{
			adapters.addItem(new RehabilitationGloveSessionListViewAdapter(null, healthActionModelDetailsProvider));
		}


		public function createScheduledHealthActionViewAdapter(scheduleItemOccurrence:ScheduleItemOccurrence,
															   healthActionModelDetailsProvider:IHealthActionModelDetailsProvider,
															   currentHealthActionListViewAdapter:IHealthActionListViewAdapter):IHealthActionListViewAdapter
		{
			var healthActionSchedule:HealthActionSchedule = scheduleItemOccurrence.scheduleItem as HealthActionSchedule;
			// TODO: perform additional check(s) to ensure that this healthActionSchedule is a PD health action; we must avoid creating/modifying the adapter for other health action schedules 
			if (healthActionSchedule && healthActionSchedule.scheduledEquipment && healthActionModelDetailsProvider.record )
			{
				if (healthActionSchedule.name.text == PDModel.REHABILITATION_GLOVE_SESSION_HEALTH_ACTION)
				{
					return new RehabilitationGloveSessionListViewAdapter(scheduleItemOccurrence, healthActionModelDetailsProvider);
				}
				else (healthActionSchedule.name.text = PDModel.TREMO_CUP_HEALTH_ACTION)
				{
					return new TremoCupListViewAdapter(scheduleItemOccurrence, healthActionModelDetailsProvider);
				}
			}

			return currentHealthActionListViewAdapter;
		}
	}
}
