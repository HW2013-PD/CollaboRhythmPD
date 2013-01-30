package collaboRhythm.plugins.medications.model
{
	import collaboRhythm.plugins.schedule.shared.model.IHealthActionModelDetailsProvider;
	import collaboRhythm.shared.model.RecurrenceRule;
	import collaboRhythm.shared.model.healthRecord.CodedValue;
	import collaboRhythm.shared.model.healthRecord.document.HealthActionPlan;
	import collaboRhythm.shared.model.healthRecord.document.HealthActionResult;
	import collaboRhythm.shared.model.healthRecord.document.HealthActionSchedule;
	import collaboRhythm.shared.model.healthRecord.document.MedicationAdministration;
	import collaboRhythm.shared.model.healthRecord.document.ScheduleItemBase;
	import collaboRhythm.shared.model.healthRecord.document.ScheduleItemOccurrence;
	import collaboRhythm.shared.model.healthRecord.document.healthActionPlan.ActionStep;
	import collaboRhythm.shared.model.services.ICurrentDateSource;
	import collaboRhythm.shared.model.services.WorkstationKernel;

	import mx.collections.ArrayCollection;

	public class RehabilitationGloveSessionScheduler
	{
		public static const REHABILITATION_GLOVE_SESSION_HEALTH_ACTION:String = "Rehabilitation Glove Session";

		private static const MILLISECONDS_IN_ONE_HOUR:int = 1000 * 60 * 60;
		private static const MILLISECONDS_IN_TWO_HOURS:int = MILLISECONDS_IN_ONE_HOUR * 2;

		private var _healthActionModelDetailsProvider:IHealthActionModelDetailsProvider;
		private var _currentDateSource:ICurrentDateSource;
		private var _triggeringMedicationAdministration:MedicationAdministration;

		public function RehabilitationGloveSessionScheduler(healthActionModelDetailsProvider:IHealthActionModelDetailsProvider,
															triggeringMedicationAdministration:MedicationAdministration)
		{
			_healthActionModelDetailsProvider = healthActionModelDetailsProvider;
			_triggeringMedicationAdministration = triggeringMedicationAdministration;
			_currentDateSource = WorkstationKernel.instance.resolve(ICurrentDateSource) as ICurrentDateSource;
		}

		public function isRehabilitationGloveSessionScheduled():Boolean
		{
			var matchingScheduleItemOccurrencesInWindow:Vector.<ScheduleItemOccurrence> = getMatchingScheduleItemOccurrencesInWindow(getScheduleDateStart(), MILLISECONDS_IN_ONE_HOUR);
			return matchingScheduleItemOccurrencesInWindow && matchingScheduleItemOccurrencesInWindow.length > 0;
		}

		private function getMatchingScheduleItemOccurrencesInWindow(expectedScheduledTime:Date, delta:Number):Vector.<ScheduleItemOccurrence>
		{
			var windowStart:Date = new Date(expectedScheduledTime.valueOf() - delta);
			var windowEnd:Date = new Date(expectedScheduledTime.valueOf() + delta);

			var occurrences:Vector.<ScheduleItemOccurrence> = new Vector.<ScheduleItemOccurrence>();
			for each (var schedule:HealthActionSchedule in
					_healthActionModelDetailsProvider.record.healthActionSchedulesModel.healthActionScheduleCollection)
			{
				if (schedule.name.text == REHABILITATION_GLOVE_SESSION_HEALTH_ACTION)
				{
					for each (var occurrence:ScheduleItemOccurrence in
							schedule.getScheduleItemOccurrences(windowStart, windowEnd, true))
					{
						occurrences.push(occurrence);
					}
				}
			}
			return occurrences;
		}

		public function scheduleRehabilitationGloveSession(initiatedLocally:Boolean):void
		{
			var rehabilitationGloveSessionHealthActionPlan:HealthActionPlan = new HealthActionPlan();
			var rehabilitationGloveSessionHealthActionSchedule:HealthActionSchedule = new HealthActionSchedule();

			rehabilitationGloveSessionHealthActionPlan.name = new CodedValue(null, null, null, REHABILITATION_GLOVE_SESSION_HEALTH_ACTION);
			rehabilitationGloveSessionHealthActionPlan.planType = "Prescribed";
			rehabilitationGloveSessionHealthActionPlan.plannedBy = _healthActionModelDetailsProvider.accountId;
			rehabilitationGloveSessionHealthActionPlan.datePlanned = _currentDateSource.now();
			rehabilitationGloveSessionHealthActionPlan.indication = "Parkinson's Disease";
			rehabilitationGloveSessionHealthActionPlan.instructions = "Use the glove to play the game";
			rehabilitationGloveSessionHealthActionPlan.system = new CodedValue(null, null, null, "PD Rehabilitation Game");
			var actions:ArrayCollection = new ArrayCollection();
			var action:ActionStep = new ActionStep();
			action.name = new CodedValue(null, null, null, "Play one session of the game");
			action.type = new CodedValue(null, null, null, "Play");
			actions.addItem(action);
			rehabilitationGloveSessionHealthActionPlan.actions = actions;

			rehabilitationGloveSessionHealthActionSchedule.name = rehabilitationGloveSessionHealthActionPlan.name.clone();
			rehabilitationGloveSessionHealthActionSchedule.scheduledBy = _healthActionModelDetailsProvider.accountId;
			rehabilitationGloveSessionHealthActionSchedule.dateScheduled = _currentDateSource.now();
			rehabilitationGloveSessionHealthActionSchedule.dateStart = getScheduleDateStart();
			rehabilitationGloveSessionHealthActionSchedule.dateEnd = new Date(rehabilitationGloveSessionHealthActionSchedule.dateStart.time + MILLISECONDS_IN_TWO_HOURS);
			var recurrenceRule:RecurrenceRule = new RecurrenceRule();
			recurrenceRule.frequency = new CodedValue(null, null, null, ScheduleItemBase.DAILY);
			recurrenceRule.count = 90;
			rehabilitationGloveSessionHealthActionSchedule.recurrenceRule = recurrenceRule;

			rehabilitationGloveSessionHealthActionPlan.schedules.addItem(rehabilitationGloveSessionHealthActionSchedule);
			rehabilitationGloveSessionHealthActionSchedule.scheduledHealthAction = rehabilitationGloveSessionHealthActionPlan;

			_healthActionModelDetailsProvider.record.addDocument(rehabilitationGloveSessionHealthActionPlan, initiatedLocally);
			_healthActionModelDetailsProvider.record.addDocument(rehabilitationGloveSessionHealthActionSchedule, initiatedLocally);
			_healthActionModelDetailsProvider.record.addRelationship(ScheduleItemBase.RELATION_TYPE_HEALTH_ACTION_SCHEDULE, rehabilitationGloveSessionHealthActionPlan, rehabilitationGloveSessionHealthActionSchedule, initiatedLocally);
			//_healthActionModelDetailsProvider.record.addRelationship(ScheduleItemBase.RELATION_TYPE_SCHEDULE_ITEM, rehabilitationGloveSessionHealthActionSchedule, rehabilitationGloveSessionHealthActionPlan, initiatedLocally);
			_healthActionModelDetailsProvider.record.addRelationship(HealthActionResult.RELATION_TYPE_TRIGGERED_HEALTH_ACTION_RESULT, _triggeringMedicationAdministration, rehabilitationGloveSessionHealthActionPlan, initiatedLocally);
		}

		private function getScheduleDateStart():Date
		{
			return new Date(_triggeringMedicationAdministration.dateAdministered.valueOf() + MILLISECONDS_IN_TWO_HOURS);
		}

		public function medicationShouldTriggerSession():Boolean
		{
			return false;
		}
	}
}
