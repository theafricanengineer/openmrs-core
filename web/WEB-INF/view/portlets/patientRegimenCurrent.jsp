<%@ include file="/WEB-INF/template/include.jsp" %>

<% java.sql.Timestamp now = new java.sql.Timestamp(System.currentTimeMillis()); %>

<openmrs:htmlInclude file="/dwr/interface/DWROrderService.js" />
<openmrs:htmlInclude file="/dwr/engine.js" />
<openmrs:htmlInclude file="/dwr/util.js" />
<openmrs:htmlInclude file="/scripts/drugOrder.js" />

		<div id="regimenPortletCurrent">
			<table>
				<thead>
					<tr>
						<th> <spring:message code="Order.item.ordered" /> </th>
						<th> <spring:message code="DrugOrder.dose"/>/<spring:message code="DrugOrder.units"/> </th>
						<th> <spring:message code="DrugOrder.frequency"/> </th>
						<th> <spring:message code="general.dateStart"/> </th>
						<th> <spring:message code="DrugOrder.scheduledStopDate"/> </th>
						<th> <spring:message code="general.instructions" /> </th>
						<c:if test="${model.currentRegimenMode != 'view'}">
							<th> </th>
							<th> </th>
						</c:if>
					</tr>
				</thead>
<c:choose>
	<c:when test="${not empty model.displayDrugSetIds}">
		<c:forTokens var="drugSetId" items="${model.displayDrugSetIds}" delims=",">
			<c:if test="${drugSetId == '*'}" >
				<tbody id="regimenTableCurrent_header___other__">
					<tr>
						<c:choose>
							<c:when test="${model.currentRegimenMode == 'view'}">
								<td colspan="6"><table><tr><td><spring:message code="DrugOrder.header.otherRegimens" /></td></tr></table></td>
							</c:when>
							<c:otherwise>
								<td colspan="8"><table><tr><td><spring:message code="DrugOrder.header.otherRegimens" /></td></tr></table></td>
							</c:otherwise>
						</c:choose>
					</tr>
				</tbody>
				<tbody id="regimenTableCurrent___other__">
					<c:if test="${not empty model.currentDrugOrderSets['*']}">
						<c:forEach items="${model.currentDrugOrderSets['*']}" var="drugOrder">
							<tr>
								<td>&nbsp;&nbsp;&nbsp;&nbsp;${drugOrder.drug.name}</td>
								<td>${drugOrder.dose}</td>
								<td>${drugOrder.frequency}</td>
								<td><openmrs:formatDate date="${drugOrder.startDate}" /></td>
								<td><openmrs:formatDate date="${drugOrder.autoExpireDate}" /></td>
								<td>${drugOrder.instructions}</td>
								<c:if test="${model.currentRegimenMode != 'view'}">
									<td>
										<input id="closebutton_${drugOrder.orderId}" type="button" value="<spring:message code="general.close" />" onClick="showHideDiv('close_${drugOrder.orderId}');showHideDiv('closebutton_${drugOrder.orderId}')" />
										<div id="close_${drugOrder.orderId}" style="display:none">
											<form>
												<spring:message code="DrugOrder.discontinuedDate" />:
												<input type="text" id="close_${drugOrder.orderId}_date" size="10" value="" onFocus="showCalendar(this)" />
												&nbsp;&nbsp;&nbsp;&nbsp;
												<spring:message code="general.reason" />:
												<input type="text" id="close_${drugOrder.orderId}_reason" size="10" value="" />
												&nbsp;&nbsp;
												<input type="button" value="<spring:message code="general.save" />" onClick="handleDiscontinueDrugOrder('${drugOrder.orderId}', 'close_${drugOrder.orderId}_date', 'close_${drugOrder.orderId}_reason')" />
											</form>
										</div>
									</td>
									<td>
										<input id="voidbutton_${drugOrder.orderId}" type="button" value="<spring:message code="general.void" />" onClick="showHideDiv('void_${drugOrder.orderId}');showHideDiv('voidbutton_${drugOrder.orderId}')" />
										<div id="void_${drugOrder.orderId}" style="display:none">
											<form>
												<spring:message code="general.reason" />: 
												<input type="text" id="void_${drugOrder.orderId}_reason" size="10" value="" />
												&nbsp;&nbsp;
												<input type="button" value="<spring:message code="general.save" />" onClick="handleVoidDrugOrder('${drugOrder.orderId}', 'void_${drugOrder.orderId}_reason')" />
											</form>
										</div>
									</td>
								</c:if>
							</tr>
						</c:forEach>
					</c:if>
					<c:if test="${empty model.currentDrugOrderSets['*']}">
						<tr>
							<c:choose>
								<c:when test="${model.currentRegimenMode == 'view'}">
									<td colspan="6"><span class="noOrdersMessage">&nbsp;&nbsp;&nbsp;&nbsp;(<spring:message code="DrugOrder.list.noOrders" />)</span></td>
								</c:when>
								<c:otherwise>
									<td colspan="8"><span class="noOrdersMessage">&nbsp;&nbsp;&nbsp;&nbsp;(<spring:message code="DrugOrder.list.noOrders" />)</span></td>
								</c:otherwise>
							</c:choose>
						</tr>
					</c:if>
				</tbody>
			</c:if>
			<c:if test="${drugSetId != '*'}" >
				<tbody id="regimenTableCurrent_header_${fn:replace(drugSetId, " ", "_")}">
					<tr>
						<c:choose>
							<c:when test="${model.currentRegimenMode == 'view'}">
								<td colspan="6">
							</c:when>
							<c:otherwise>
								<td colspan="8">
							</c:otherwise>
						</c:choose>
							<table>
								<tr>
									<td><openmrs_tag:concept conceptId="${model.drugOrderHeaders[drugSetId].conceptId}" /></td>
									<c:if test="${(model.currentRegimenMode != 'view') && (not empty model.currentDrugOrderSets[drugSetId])}">
										<td>
											<input id="closegpbutton_${fn:replace(drugSetId, " ", "_")}" type="button" value="<spring:message code="general.closeGroup" />" onClick="showHideDiv('closegp_${fn:replace(drugSetId, " ", "_")}');showHideDiv('closegpbutton_${fn:replace(drugSetId, " ", "_")}')" />
											<div id="closegp_${fn:replace(drugSetId, " ", "_")}" style="display:none">
												<form>
													<spring:message code="DrugOrder.discontinuedDate" />:
													<input type="text" id="closegp_${fn:replace(drugSetId, " ", "_")}_date" size="10" value="" onFocus="showCalendar(this)" />
													&nbsp;&nbsp;&nbsp;&nbsp;
													<spring:message code="general.reason" />:
													<input type="text" id="closegp_${fn:replace(drugSetId, " ", "_")}_reason" size="10" value="" />
													&nbsp;&nbsp;
													<input type="button" value="<spring:message code="general.save" />" onClick="handleDiscontinueDrugSet('${drugSetId}', 'closegp_${fn:replace(drugSetId, " ", "_")}_date', 'closegp_${fn:replace(drugSetId, " ", "_")}_reason')" />
												</form>
											</div>
										</td>
										<td>
											<input id="voidgpbutton_${fn:replace(drugSetId, " ", "_")}" type="button" value="<spring:message code="general.voidGroup" />" onClick="showHideDiv('voidgp_${fn:replace(drugSetId, " ", "_")}');showHideDiv('voidgpbutton_${fn:replace(drugSetId, " ", "_")}')" />
											<div id="voidgp_${fn:replace(drugSetId, " ", "_")}" style="display:none">
												<form>
													<spring:message code="general.reason" />:
													<input type="text" id="voidgp_${fn:replace(drugSetId, " ", "_")}_reason" size="10" value="" />
													&nbsp;&nbsp;
													<input type="button" value="<spring:message code="general.save" />" onClick="handleVoidCurrentDrugSet('${drugSetId}', 'voidgp_${fn:replace(drugSetId, " ", "_")}_reason')" />
												</form>
											</div>
										</td>
									</c:if>
								</tr>
							</table>
						</td>
					</tr>
				</tbody>
				<tbody id="regimenTableCurrent_${fn:replace(drugSetId, " ", "_")}">
					<c:if test="${not empty model.currentDrugOrderSets[drugSetId]}">
						<c:forEach items="${model.currentDrugOrderSets[drugSetId]}" var="drugOrder">
							<tr>
								<td>&nbsp;&nbsp;&nbsp;&nbsp;${drugOrder.drug.name}</td>
								<td>${drugOrder.dose}</td>
								<td>${drugOrder.frequency}</td>
								<td><openmrs:formatDate date="${drugOrder.startDate}" /></td>
								<td><openmrs:formatDate date="${drugOrder.autoExpireDate}" /></td>
								<td>${drugOrder.instructions}</td>
								<c:if test="${model.currentRegimenMode != 'view'}">
									<td>
										<input id="closebutton_${drugOrder.orderId}" type="button" value="<spring:message code="general.close" />" onClick="showHideDiv('close_${drugOrder.orderId}');showHideDiv('closebutton_${drugOrder.orderId}')" />
										<div id="close_${drugOrder.orderId}" style="display:none">
											<form>
												<spring:message code="DrugOrder.discontinuedDate" />:
												<input type="text" id="close_${drugOrder.orderId}_date" size="10" value="" onFocus="showCalendar(this)" />
												&nbsp;&nbsp;&nbsp;&nbsp;
												<spring:message code="general.reason" />:
												<input type="text" id="close_${drugOrder.orderId}_reason" size="10" value="" />
												&nbsp;&nbsp;
												<input type="button" value="<spring:message code="general.save" />" onClick="handleDiscontinueDrugOrder('${drugOrder.orderId}', 'close_${drugOrder.orderId}_date', 'close_${drugOrder.orderId}_reason')" />
											</form>
										</div>
									</td>
									<td>
										<input id="voidbutton_${drugOrder.orderId}" type="button" value="<spring:message code="general.void" />" onClick="showHideDiv('void_${drugOrder.orderId}');showHideDiv('voidbutton_${drugOrder.orderId}')" />
										<div id="void_${drugOrder.orderId}" style="display:none">
											<form>
												<spring:message code="general.reason" />: 
												<input type="text" id="void_${drugOrder.orderId}_reason" size="10" value="" />
												&nbsp;&nbsp;
												<input type="button" value="<spring:message code="general.save" />" onClick="handleVoidDrugOrder('${drugOrder.orderId}', 'void_${drugOrder.orderId}_reason')" />
											</form>
										</div>
									</td>
								</c:if>
							</tr>
						</c:forEach>
					</c:if>
					<c:if test="${empty model.currentDrugOrderSets[drugSetId]}">
						<tr>
							<c:choose>
								<c:when test="${model.currentRegimenMode == 'view'}">
									<td colspan="6"><span class="noOrdersMessage">&nbsp;&nbsp;&nbsp;&nbsp;(<spring:message code="DrugOrder.list.noOrders" />)</span></td>
								</c:when>
								<c:otherwise>
									<td colspan="8"><span class="noOrdersMessage">&nbsp;&nbsp;&nbsp;&nbsp;(<spring:message code="DrugOrder.list.noOrders" />)</span></td>
								</c:otherwise>
							</c:choose>
						</tr>
					</c:if>
				</tbody>
			</c:if>
		</c:forTokens>
	</c:when>
	<c:otherwise>
				<tbody id="regimenTableCurrent">
					<c:if test="${not empty model.currentDrugOrders}">
						<c:forEach items="${model.currentDrugOrders}" var="drugOrder">
							<tr>
								<td>${drugOrder.drug.name}</td>
								<td>${drugOrder.dose}</td>
								<td>${drugOrder.frequency}</td>
								<td><openmrs:formatDate date="${drugOrder.startDate}" /></td>
								<td><openmrs:formatDate date="${drugOrder.autoExpireDate}" /></td>
								<td>${drugOrder.instructions}</td>
								<c:if test="${model.currentRegimenMode != 'view'}">
									<td>
										<input id="closebutton_${drugOrder.orderId}" type="button" value="<spring:message code="general.close" />" onClick="showHideDiv('close_${drugOrder.orderId}');showHideDiv('closebutton_${drugOrder.orderId}')" />
										<div id="close_${drugOrder.orderId}" style="display:none">
											<form>
												<spring:message code="DrugOrder.discontinuedDate" />:
												<input type="text" id="close_${drugOrder.orderId}_date" size="10" value="" onFocus="showCalendar(this)" />
												&nbsp;&nbsp;&nbsp;&nbsp;
												<spring:message code="general.reason" />:
												<input type="text" id="close_${drugOrder.orderId}_reason" size="10" value="" />
												&nbsp;&nbsp;
												<input type="button" value="<spring:message code="general.save" />" onClick="handleDiscontinueDrugOrder('${drugOrder.orderId}', 'close_${drugOrder.orderId}_date', 'close_${drugOrder.orderId}_reason')" />
											</form>
										</div>
									</td>
									<td>
										<input id="voidbutton_${drugOrder.orderId}" type="button" value="<spring:message code="general.void" />" onClick="showHideDiv('void_${drugOrder.orderId}');showHideDiv('voidbutton_${drugOrder.orderId}')" />
										<div id="void_${drugOrder.orderId}" style="display:none">
											<form>
												<spring:message code="general.reason" />: 
												<input type="text" id="void_${drugOrder.orderId}_reason" size="10" value="" />
												&nbsp;&nbsp;
												<input type="button" value="<spring:message code="general.save" />" onClick="handleVoidDrugOrder('${drugOrder.orderId}', 'void_${drugOrder.orderId}_reason')" />
											</form>
										</div>
									</td>
								</c:if>
							</tr>
						</c:forEach>
					</c:if>
					<c:if test="${empty model.currentDrugOrders}">
						<tr>
							<c:choose>
								<c:when test="${model.currentRegimenMode == 'view'}">
									<td colspan="6"><span class="noOrdersMessage">(<spring:message code="DrugOrder.list.noOrders" />)</span></td>
								</c:when>
								<c:otherwise>
									<td colspan="8"><span class="noOrdersMessage">(<spring:message code="DrugOrder.list.noOrders" />)</span></td>
								</c:otherwise>
							</c:choose>
						</tr>
					</c:if>
				</tbody>
	</c:otherwise>
</c:choose>
			</table>
			<script>
				setPatientId("${model.patientId}");
				setDisplayDrugSetIds("${model.displayDrugSetIds}");
				setRegimenMode("${model.currentRegimenMode}");
			</script>
		</div>

