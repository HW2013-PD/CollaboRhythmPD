package collaboRhythm.plugins.medications.model
{
	import collaboRhythm.plugins.schedule.shared.model.HealthActionInputModelBase;
	import collaboRhythm.plugins.schedule.shared.model.IHealthActionInputModel;
	import collaboRhythm.plugins.schedule.shared.model.IHealthActionModelDetailsProvider;
	import collaboRhythm.plugins.schedule.shared.model.IScheduleCollectionsProvider;
	import collaboRhythm.shared.model.RecurrenceRule;
	import collaboRhythm.shared.model.healthRecord.CodedValue;
	import collaboRhythm.shared.model.healthRecord.CodedValue;
	import collaboRhythm.shared.model.healthRecord.DocumentBase;
	import collaboRhythm.shared.model.healthRecord.document.HealthActionPlan;
	import collaboRhythm.shared.model.healthRecord.document.HealthActionSchedule;
	import collaboRhythm.shared.model.healthRecord.document.MedicationAdministration;
	import collaboRhythm.shared.model.healthRecord.document.MedicationOrder;
	import collaboRhythm.shared.model.healthRecord.document.MedicationScheduleItem;
	import collaboRhythm.shared.model.healthRecord.document.ScheduleItemBase;
	import collaboRhythm.shared.model.healthRecord.document.ScheduleItemOccurrence;
	import collaboRhythm.shared.model.healthRecord.document.healthActionPlan.ActionStep;

	import mx.collections.ArrayCollection;

	[Bindable]
	public class MedicationHealthActionInputModel extends HealthActionInputModelBase implements IHealthActionInputModel
	{
		public static const REHABILITATION_GLOVE_SESSION_HEALTH_ACTION:String = "Rehabilitation Glove Session";

		private var _medicationScheduleItem:MedicationScheduleItem;
		private var _medicationOrder:MedicationOrder;
		private var _dateMeasuredStart:Date;
		private const MILLISECONDS_IN_TWO_HOURS:int = 1000 * 60 * 60 * 2;

		public function MedicationHealthActionInputModel(scheduleItemOccurrence:ScheduleItemOccurrence,
														 healthActionModelDetailsProvider:IHealthActionModelDetailsProvider,
														 scheduleCollectionsProvider:IScheduleCollectionsProvider)
		{
			super(scheduleItemOccurrence, healthActionModelDetailsProvider, scheduleCollectionsProvider);

			if (scheduleItemOccurrence)
			{
				_medicationScheduleItem = scheduleItemOccurrence.scheduleItem as MedicationScheduleItem;
				_medicationOrder = _medicationScheduleItem.scheduledMedicationOrder;
			}

			dateMeasuredStart = _currentDateSource.now();
		}

		public function handleHealthActionResult(initiatedLocally:Boolean):void
		{
			createMedicationAdministration(initiatedLocally);

			scheduleRehabilitationGloveSession(initiatedLocally);
		}

		private function scheduleRehabilitationGloveSession(initiatedLocally:Boolean):void
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

			rehabilitationGloveSessionHealthActionSchedule.name = rehabilitationGloveSessionHealthActionPlan.name;
			rehabilitationGloveSessionHealthActionSchedule.scheduledBy = _healthActionModelDetailsProvider.accountId;
			rehabilitationGloveSessionHealthActionSchedule.dateScheduled = _currentDateSource.now();
			rehabilitationGloveSessionHealthActionSchedule.dateStart = new Date(_currentDateSource.now().time + MILLISECONDS_IN_TWO_HOURS);
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
			_healthActionModelDetailsProvider.record.addRelationship(ScheduleItemBase.RELATION_TYPE_SCHEDULE_ITEM, rehabilitationGloveSessionHealthActionSchedule, rehabilitationGloveSessionHealthActionPlan, initiatedLocally);

		}

		public function createMedicationAdministration(initiatedLocally:Boolean):void
		{
			if (_medicationScheduleItem)
			{
				var medicationAdministration:MedicationAdministration = new MedicationAdministration();
				medicationAdministration.init(_medicationOrder ? _medicationOrder.name : _medicationScheduleItem.name,
						healthActionModelDetailsProvider.accountId,
						dateMeasuredStart, dateMeasuredStart, _medicationScheduleItem.dose);

				var adherenceResults:Vector.<DocumentBase> = new Vector.<DocumentBase>();
				adherenceResults.push(medicationAdministration);
				scheduleItemOccurrence.createAdherenceItem(adherenceResults,
						healthActionModelDetailsProvider.record, healthActionModelDetailsProvider.accountId,
						initiatedLocally);
			}
		}

		public function saveAllChanges():void
		{
			healthActionModelDetailsProvider.record.saveAllChanges();
		}

		public function get adherenceResultDate():Date
		{
			var adherenceResultDate:Date;

			if (scheduleItemOccurrence && scheduleItemOccurrence.adherenceItem &&
					scheduleItemOccurrence.adherenceItem.adherenceResults &&
					scheduleItemOccurrence.adherenceItem.adherenceResults.length != 0)
			{
				var medicationAdministration:MedicationAdministration = scheduleItemOccurrence.adherenceItem.adherenceResults[0] as
						MedicationAdministration;
				adherenceResultDate = medicationAdministration.dateAdministered;
			}

			return adherenceResultDate;
		}

		public function get dateMeasuredStart():Date
		{
			return _dateMeasuredStart;
		}

		public function set dateMeasuredStart(value:Date):void
		{
			_dateMeasuredStart = value;
		}

		public function get isChangeTimeAllowed():Boolean
		{
			return true;
		}
	}
}
